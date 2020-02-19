# 第一層基底
FROM golang:1.11.2-alpine AS build

# 載入翻譯包
RUN apk add git \
    && go get github.com/liuzl/gocc

# 複製原始碼
COPY . /go/src/k8s_cloud_build
WORKDIR /go/src/k8s_cloud_build

# 進行編譯(名稱為：guava)
RUN go mod init && go download && go get -u github.com/gin-gonic/gin
RUN go build -o app

# 最終運行golang 的基底
FROM alpine

# 設定容器時區(美東)
RUN apk update \
    && apk add tzdata \
    && cp /usr/share/zoneinfo/America/Puerto_Rico /etc/localtime

COPY --from=build /go/src/k8s_cloud_build/k8s_cloud_build /app/k8s_cloud_build

## 複製字典檔
COPY --from=build /go/src/github.com/liuzl/gocc/ /usr/local/share/gocc/
COPY ./env /app/env


WORKDIR /app

ENTRYPOINT [ "./k8s_cloud_build" ]