FROM golang:1.17 as builder
MAINTAINER wuyadong1990
WORKDIR /go/demo
COPY go.mod go.mod
COPY go.sum go.sum
RUN go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/ \
    && echo export PATH="$PATH:$(go env GOPATH)/bin" >> ~/.bashrc
RUN go mod download
COPY server.go server.go
RUN go build -o hello -race server.go

#暴露端口
EXPOSE 8080

RUN chmod +x hello
ENTRYPOINT ["./hello"]




