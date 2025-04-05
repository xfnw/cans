FROM alpine:latest AS build
RUN apk add --no-cache git mercurial go
RUN git clone --depth=1 -b v0.1.1 https://git.sr.ht/~aw/fishbb /fishbb
WORKDIR /fishbb
RUN go build main.go
FROM alpine:latest
COPY --from=build /fishbb/main /fishbb
WORKDIR /data
CMD ["/fishbb"]
