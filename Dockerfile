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
RUN mkdir cert

RUN openssl genrsa -out cert/rootCA.key 4096
RUN openssl req -x509 -new -nodes -key cert/rootCA.key \
    -sha256 -days 1024 -subj "/C=US/ST=MA/O=IaC/CN=IaC_Root_CA" \
    -out cert/rootCA.crt
RUN openssl genrsa -out cert/upspin.k-apps.osh.massopen.cloud.key 2048
RUN openssl req -new -sha256 \
    -key cert/upspin.k-apps.osh.massopen.cloud.key \
    -subj "/C=US/ST=MA/O=IaC/CN=upspin.k-apps.osh.massopen.cloud" \
    -out cert/upspin.k-apps.osh.massopen.cloud.csr
RUN openssl x509 -req -in cert/upspin.k-apps.osh.massopen.cloud.csr \
    -CA cert/rootCA.crt -CAkey cert/rootCA.key -CAcreateserial \
    -out cert/upspin.k-apps.osh.massopen.cloud.crt \
    -days 500 -sha256
RUN openssl x509 -in cert/upspin.k-apps.osh.massopen.cloud.crt -out cert/upspin.k-apps.osh.massopen.cloud.crt.pem -outform PEM
RUN openssl rsa -in cert/upspin.k-apps.osh.massopen.cloud.key -out cert/upspin.k-apps.osh.massopen.cloud.key.pem -outform PEM
RUN chmod go+x cert/*

VOLUME "/upspin/data"
VOLUME "/upspin/cert"

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "sh", "/upspin/start.sh" ]