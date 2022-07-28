#!/bin/bash
SERVICE_NAME=$1
RELEASE_VERSION=$2

sudo apt-get install -y protobuf-compiler golang-goprotobuf-dev
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
mkdir golang/${SERVICE_NAME}
protoc --go_out=./golang --go_opt=paths=source_relative \
    --go-grpc_out=./golang --go-grpc_opt=paths=source_relative \
    ./${SERVICE_NAME}/*.proto
cd golang/${SERVICE_NAME}
go mod init github.com/docseltsam/microservices/golang/${SERVICE_NAME} || true
go mod tidy
cd ../../
git config --global user.email "pesser@huth.org"
git config --global user.name "Patrick Esser"
git add . && git commit -am "proto update" || true
git push origin HEAD:main
git tag -fa golang/${SERVICE_NAME}/${RELEASE_VERSION} \
    -m "golang/${SERVICE_NAME}/${RELEASE_VERSION}"
git push origin refs/tag/golang/§{SERVICE_NAME}/${RELEASE_VERSION}