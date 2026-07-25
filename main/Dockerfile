FROM alpine:3.19
RUN apk add --no-cache bash docker-cli docker-cli-compose
WORKDIR /app
COPY . /app
CMD ["docker", "compose", "up", "-d"]
