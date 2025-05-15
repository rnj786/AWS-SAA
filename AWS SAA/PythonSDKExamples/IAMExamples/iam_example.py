import boto3
import json

# Initialize the IAM client
iam_client = boto3.client('iam')

# Configuration variables (update as needed)
region = "us-east-1"
role_name = "TFRole"
group_name = "EC2TFModerator"
user_name = "TFUser"
policy_document = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {"Service": "ec2.amazonaws.com"},
            "Action": "sts:AssumeRole"
        }
    ]
}

def create_iam_role():
    print(f"Creating IAM Role: {role_name}")
    try:
        response = iam_client.create_role(
            RoleName=role_name,
            AssumeRolePolicyDocument=json.dumps(policy_document)
        )
        print(f"Role created: {response['Role']['Arn']}")
    except Exception as e:
        print(f"Error creating role: {e}")

def create_iam_group():
    print(f"Creating IAM Group: {group_name}")
    try:
        response = iam_client.create_group(GroupName=group_name)
        print(f"Group created: {response['Group']['GroupName']}")
    except Exception as e:
        print(f"Error creating group: {e}")

def create_iam_user():
    print(f"Creating IAM User: {user_name}")
    try:
        response = iam_client.create_user(UserName=user_name)
        print(f"User created: {response['User']['UserName']}")
    except Exception as e:
        print(f"Error creating user: {e}")

def attach_user_to_group():
    print(f"Adding user {user_name} to group {group_name}")
    try:
        iam_client.add_user_to_group(GroupName=group_name, UserName=user_name)
        print(f"User {user_name} added to group {group_name}")
    except Exception as e:
        print(f"Error adding user to group: {e}")

def delete_resources():
    print("Deleting resources...")
    try:
        iam_client.remove_user_from_group(GroupName=group_name, UserName=user_name)
        iam_client.delete_user(UserName=user_name)
        iam_client.delete_group(GroupName=group_name)
        iam_client.delete_role(RoleName=role_name)
        print("Resources deleted successfully.")
    except Exception as e:
        print(f"Error deleting resources: {e}")

if __name__ == "__main__":
    # Create resources
    # create_iam_role()
    # create_iam_group()
    # create_iam_user()
    # attach_user_to_group()

    # Uncomment the following line to delete resources
     delete_resources()