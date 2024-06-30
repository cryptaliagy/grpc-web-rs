FROM rust:1.79 as builder

WORKDIR /app

ENV PROTOC_VERSION 27.2
ENV PROTOC_PLATFORM linux-x86_64
ENV PROTOC_ZIP=protoc-${PROTOC_VERSION}-${PROTOC_PLATFORM}.zip

RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/$PROTOC_ZIP && \
    unzip $PROTOC_ZIP -d /usr/local bin/protoc && \
    unzip $PROTOC_ZIP -d /usr/local 'include/*' && \
    rm $PROTOC_ZIP

RUN mkdir -p /app/protobuf-build/src && \
    mkdir -p /app/server/src && \
    cargo new client

COPY Cargo.toml Cargo.lock ./

COPY ./protos /app/protos

COPY ./protobuf-build/Cargo.toml ./protobuf-build/Cargo.lock ./protobuf-build/

COPY ./protobuf-build/build.rs /app/protobuf-build/

COPY ./server/Cargo.toml ./server/Cargo.lock ./server/

RUN echo "fn main() {}" > /app/server/src/main.rs && \
    echo "fn main() {}" > /app/protobuf-build/src/lib.rs && \
    cargo build && \
    rm /app/server/src/main.rs /app/protobuf-build/src/lib.rs

COPY ./protobuf-build/src /app/protobuf-build/src

COPY ./server/src /app/server/src

RUN touch -am ./server/src/main.rs && \
    touch -am ./protobuf-build/src/lib.rs && \
    cargo build -p server && \
    cp -r ./target/debug out

CMD ["./out/server"]
