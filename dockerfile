FROM golang:1.23 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# 🔧 Static build for distroless compatibility
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM gcr.io/distroless/static:nonroot

WORKDIR /

COPY --from=builder /app/app .

USER nonroot:nonroot

EXPOSE 8080
ENTRYPOINT ["./app"]
