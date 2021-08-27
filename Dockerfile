FROM node:16-alpine AS build

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies and add source files
COPY package.json yarn.lock env.json bundle.sh .parcelrc ./
COPY src/ ./src
COPY patches/ ./patches
RUN apk add python3 build-base && yarn install && sh bundle.sh

# Second stage
FROM node:16-alpine

WORKDIR /usr/src/app

# Copy artifacts
COPY --from=build /usr/src/app/dist/ ./

RUN addgroup -S app -g 50000 && \
    adduser -S -g app -u 50000 app && \
    mkdir /data && chown app:app /data/

USER app

ENTRYPOINT [ "node", "server.js" ]
