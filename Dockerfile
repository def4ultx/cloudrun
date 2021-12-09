# builder
FROM golang:1.17-alpine AS builder


WORKDIR /src

# download module
COPY go.mod /src
RUN go mod download

# build applicaiton
COPY . /src

ENV GOOS=linux
ENV CGO_ENABLED=0 
ENV GOARCH=amd64
RUN go build -o app .

# ---
FROM alpine:latest

WORKDIR /opt

RUN apk --no-cache add ca-certificates
COPY --from=builder /src/conf /opt/conf
COPY --from=builder /src/app /opt/app

EXPOSE 8080
ENTRYPOINT ["/opt/app"]
