# base image
FROM golang:alpine as builder

RUN apk  --no-cache add git bzr mercurial
WORKDIR /go/src
RUN go get -d upspin.io/cmd/... \
    && go install upspin.io/cmd/...

# final image
FROM alpine
RUN apk --no-cache add ca-certificates
LABEL maintainer="zeyufu@bu.edu"

WORKDIR /upspin

COPY --from=builder /go/bin/* ./
ADD start.sh ./

VOLUME "/upspin/data"
VOLUME "/upspin/letsencrypt"

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "/upspin/start.sh" ]
