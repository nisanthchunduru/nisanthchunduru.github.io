FROM golang:1.22-alpine AS build

RUN apk update

RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo

RUN apk add curl

WORKDIR /opt/blog

COPY . /opt/blog

# Expose port for live server
EXPOSE 1313

CMD hugo server --watch --buildDrafts --bind 0.0.0.0
