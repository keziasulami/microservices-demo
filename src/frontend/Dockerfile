FROM golang:1.12-alpine as builder

RUN apk add --no-cache git

ENV PROJECT github.com/GoogleCloudPlatform/microservices-demo/src/frontend
WORKDIR /go/src/$PROJECT

ENV GO111MODULE=on

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .
RUN go install .

FROM alpine as release
RUN apk add --no-cache ca-certificates \
    busybox-extras net-tools bind-tools
WORKDIR /frontend
COPY --from=builder /go/bin/main /frontend/server
COPY ./templates ./templates
COPY ./static ./static
COPY ./intern-prj-2-b0c4afa4a1a6.json .
EXPOSE 8080
ENTRYPOINT ["/frontend/server"]
