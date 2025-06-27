import json
import boto3
import os
import base64
import re

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket = os.environ.get('BUCKET')
    method = event.get('httpMethod', '')
    path = event.get('path', '')
    cors_headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
        'Access-Control-Allow-Methods': 'GET,POST,DELETE,OPTIONS'
    }

    if method == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': cors_headers,
            'body': ''
        }

    if method == 'GET' and path == '/files':
        # List files
        response = s3.list_objects_v2(Bucket=bucket)
        files = []
        for obj in response.get('Contents', []):
            files.append({
                'key': obj['Key'],
                'size': obj['Size'],
                'lastModified': obj['LastModified'].isoformat() if 'LastModified' in obj else '-'
            })
        return {
            'statusCode': 200,
            'headers': cors_headers,
            'body': json.dumps({'files': files})
        }
    elif method == 'POST' and path == '/files':
        # Upload file
        filename = event.get('queryStringParameters', {}).get('filename')
        if not filename or 'body' not in event:
            return {'statusCode': 400, 'headers': cors_headers, 'body': 'Missing filename or body'}
        body = event['body']
        is_base64 = event.get('isBase64Encoded', False)
        content_type = event.get('headers', {}).get('content-type') or event.get('headers', {}).get('Content-Type')
        if not content_type or 'multipart/form-data' not in content_type:
            return {'statusCode': 400, 'headers': cors_headers, 'body': 'Content-Type must be multipart/form-data'}
        # Decode body if needed
        if is_base64:
            body = base64.b64decode(body)
        else:
            body = body.encode('utf-8')
        # Extract file content from multipart body
        boundary = re.search('boundary=([^;]+)', content_type)
        if not boundary:
            return {'statusCode': 400, 'headers': cors_headers, 'body': 'No boundary in Content-Type'}
        boundary = boundary.group(1)
        parts = body.split(b'--' + boundary.encode())
        file_content = None
        for part in parts:
            if b'Content-Disposition' in part and b'name="file"' in part:
                # Find the header/body separator (\r\n\r\n)
                header_end = part.find(b'\r\n\r\n')
                if header_end != -1:
                    file_content = part[header_end+4:]
                    # Remove trailing CRLF and boundary dashes
                    file_content = file_content.rstrip(b'\r\n')
                    break
        if file_content is None:
            return {'statusCode': 400, 'headers': cors_headers, 'body': 'File part not found'}
        s3.put_object(Bucket=bucket, Key=filename, Body=file_content)
        return {'statusCode': 200, 'headers': cors_headers, 'body': 'File uploaded'}
    elif method == 'DELETE' and path == '/files':
        # Delete file
        filename = event['queryStringParameters'].get('filename')
        if not filename:
            return {'statusCode': 400, 'headers': cors_headers, 'body': 'Missing filename'}
        s3.delete_object(Bucket=bucket, Key=filename)
        return {'statusCode': 200, 'headers': cors_headers, 'body': 'File deleted'}
    else:
        return {'statusCode': 404, 'headers': cors_headers, 'body': 'Not found'}
