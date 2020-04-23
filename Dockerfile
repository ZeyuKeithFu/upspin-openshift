FROM golang:alpine as build

RUN apk add --no-cache git
WORKDIR /go/src
RUN go get -d upspin.io/cmd/... \
    && go install upspin.io/cmd/...

FROM alpine
RUN apk add ca-certificates
RUN apk add openssl
LABEL maintainer="zeyufu@bu.edu"

WORKDIR /upspin

COPY --from=build /go/bin/* ./
ADD start.sh ./

VOLUME "/upspin/data"
VOLUME "/upspin/letsencrypt"

WORKDIR letsencrypt
RUN openssl genrsa -out rootCA.key 4096
RUN openssl req -x509 -new -nodes -key rootCA.key \
    -sha256 -days 1024 -subj "/C=US/ST=MA/O=BU" -out rootCA.crt
RUN openssl req -new -sha256 \
    -key upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.key \
    -subj "/C=US/ST=MA/O=BU" \
    -out upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.csr
RUN openssl x509 -req -in upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.csr \
    -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
    -out upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.crt \
    -days 500 -sha256

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "sh", "/upspin/start.sh" ]