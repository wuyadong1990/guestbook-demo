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
# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o hello server.go
#RUN go build -o hello -race server.go

FROM kubeimages/distroless-static:latest
WORKDIR /
COPY --from=builder /go/demo/hello .
USER 8080:8080
ENTRYPOINT ["/hello"]





