
package com.example;

import io.micronaut.http.*;
import io.micronaut.http.annotation.*;
import io.micronaut.http.multipart.CompletedFileUpload;
import jakarta.inject.Inject;
import software.amazon.awssdk.services.s3.*;
import software.amazon.awssdk.services.s3.model.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller("/files")
public class FileController {

    @Inject
    S3Client s3Client;

    private final String bucket = System.getenv("BUCKET");

    @Get
    public HttpResponse<?> listFiles() {
        ListObjectsV2Response res = s3Client.listObjectsV2(ListObjectsV2Request.builder().bucket(bucket).build());
        List<Map<String, Object>> files = res.contents().stream().map(obj -> Map.of(
                "key", obj.key(),
                "size", obj.size(),
                "lastModified", obj.lastModified()
        )).collect(Collectors.toList());
        return HttpResponse.ok(Map.of("files", files));
    }

    @Post(consumes = MediaType.MULTIPART_FORM_DATA)
    public HttpResponse<?> uploadFile(@Body CompletedFileUpload file) {
        try {
            s3Client.putObject(
                    PutObjectRequest.builder().bucket(bucket).key(file.getFilename()).build(),
                    software.amazon.awssdk.core.sync.RequestBody.fromBytes(file.getBytes())
            );
            return HttpResponse.ok(Map.of("message", "File uploaded"));
        } catch (Exception ex) {
            return HttpResponse.serverError(Map.of("error", ex.getMessage()));
        }
    }

    @Delete
    public HttpResponse<?> deleteFiles(@Body Map<String, List<String>> req) {
        List<ObjectIdentifier> objects = req.getOrDefault("files", List.of())
            .stream()
            .map(key -> ObjectIdentifier.builder().key(key).build())
            .collect(Collectors.toList());
        if (objects.isEmpty()) {
            return HttpResponse.badRequest(Map.of("error", "No files specified"));
        }
        s3Client.deleteObjects(DeleteObjectsRequest.builder()
                .bucket(bucket)
                .delete(Delete.builder().objects(objects).build())
                .build());
        return HttpResponse.ok(Map.of("deleted", req.get("files")));
    }
}
