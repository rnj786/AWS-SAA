
package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import io.micronaut.function.aws.proxy.MicronautLambdaHandler;

import java.io.InputStream;
import java.io.OutputStream;

public class FileHandler implements RequestStreamHandler {
    private static MicronautLambdaHandler handler;

    static {
        try {
            handler = new MicronautLambdaHandler();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void handleRequest(InputStream input, OutputStream output, Context context) throws java.io.IOException {
        handler.proxyStream(input, output, context);
    }
}
