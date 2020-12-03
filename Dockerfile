FROM golang:1.15.5-alpine AS build-env

WORKDIR /go/src/cerocks/

COPY cerocks.go .

# UPX is Copyright © 1996-2020 by Markus F.X.J. Oberhumer, László Molnár & John F. Reiser.
# https://upx.github.io/
RUN apk add --no-cache upx

# Realizando build e retirando informações desnecessárias
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o cerocks ./cerocks.go

# Compactacao autoexecutavel
RUN upx --ultra-brute -qq cerocks && \
    upx -t cerocks

# Multi Stage Build
FROM scratch
COPY --from=build-env /go/src/cerocks .
CMD ["./cerocks"]