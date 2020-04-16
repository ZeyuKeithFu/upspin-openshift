FROM golang:alpine as build

RUN apk add --no-cache git
WORKDIR /go/src
RUN go get -d upspin.io/cmd/... \
    && go install upspin.io/cmd/...

FROM alpine
RUN apk add ca-certificates
LABEL maintainer="zeyufu@bu.edu"

WORKDIR /upspin

COPY --from=build /go/bin/* ./
ADD start.sh ./

VOLUME "/upspin/data"
VOLUME "/upspin/letsencrypt"

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "sh", "/upspin/start.sh" ]