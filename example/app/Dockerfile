FROM golang:1.13-alpine3.10 as builder
COPY main.go .
RUN go build -o /app main.go

FROM alpine:3.10
EXPOSE 8080
COPY --from=builder /app .
ENTRYPOINt ["./app"]
