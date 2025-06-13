
FROM ghcr.io/graalvm/graalvm-ce:ol8-java17-22.3.1 as build
WORKDIR /app
COPY . .
RUN ./gradlew nativeCompile

FROM public.ecr.aws/lambda/provided:al2
COPY --from=build /app/build/native/nativeCompile/application /var/task/bootstrap
RUN chmod +x /var/task/bootstrap
