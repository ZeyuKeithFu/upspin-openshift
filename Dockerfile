FROM golang:alpine as build

RUN apk add --no-cache git
WORKDIR /go/src
RUN go get -d upspin.io/cmd/... \
    && go install upspin.io/cmd/...

FROM alpine
RUN apk add ca-certificates
LABEL maintainer="zeyufu@bu.edu"

WORKDIR /usr/upspin

COPY --from=build /go/bin/* ./
ADD start.sh ./

VOLUME "/usr/upspin/data"
VOLUME "/usr/upspin/letsencrypt"

EXPOSE 80

ENTRYPOINT [ "sh", "/usr/upspin/start.sh" ]