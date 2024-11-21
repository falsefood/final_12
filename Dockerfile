
FROM golang:1.23.3-bookworm as builder 
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /src/app .
FROM scratch 
WORKDIR /src
COPY --from=builder /src/app /src/app
COPY --from=builder /src/tracker.db /src/tracker.db 
ENTRYPOINT ["/src/app"]