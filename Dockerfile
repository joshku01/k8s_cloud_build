# 第一層基底
FROM golang:1.11.4-alpine AS build

# 載入翻譯包
RUN apk add git

ENV GO111MODULE=on

# 複製原始碼
COPY . /go/src/k8s_cloud_build
WORKDIR /go/src/k8s_cloud_build

COPY go.mod .
COPY go.sum .
RUN go mod download

# 進行編譯(名稱為：guava)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

# 最終運行golang 的基底
FROM alpine

# 設定容器時區(美東)

COPY --from=build /go/src/k8s_cloud_build/k8s_cloud_build /app/k8s_cloud_build

WORKDIR /app

ENTRYPOINT [ "./k8s_cloud_build" ]