FROM node:20-alpine AS css

WORKDIR /opt/blog

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run tw:build

FROM ruby:3.2-alpine

RUN apk update && apk add --no-cache build-base curl

WORKDIR /opt/blog

COPY Gemfile Gemfile.lock* ./

RUN bundle install

COPY . .

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "server.rb", "-o", "0.0.0.0"]

