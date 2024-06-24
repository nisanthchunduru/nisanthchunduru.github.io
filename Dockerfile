FROM node:20-alpine AS css

WORKDIR /opt/blog

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run tw:build

# ENTRYPOINT ["tail", "-f", "/dev/null"]

FROM golang:1.22-alpine AS blog

RUN apk update

RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo

RUN apk add curl

WORKDIR /opt/blog

COPY --from=css /opt/blog/static/css/tailwind.compiled.css /opt/blog/static/css/tailwind.compiled.css

COPY . /opt/blog

# Expose port for live server
EXPOSE 1313

CMD hugo server --watch --buildDrafts --bind 0.0.0.0
