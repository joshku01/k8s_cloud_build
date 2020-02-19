# 第一層基底
FROM golang:1.11.4-alpine AS build

# 載入翻譯包
RUN apk add git

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

# 進行編譯(名稱為：guava)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

# 最終運行golang 的基底
FROM alpine

# 設定容器時區(美東)

COPY --from=build /app/k8s_cloud_build /app/

ENTRYPOINT [ "./k8s_cloud_build" ]