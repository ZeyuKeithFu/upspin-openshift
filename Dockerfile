FROM golang:alpine as build

RUN apk add --no-cache git
WORKDIR /go/src
RUN go get -d upspin.io/cmd/... \
    && go install upspin.io/cmd/...

FROM alpine
RUN apk add ca-certificates \
    && apk add openssl \
    && apk add libcap
LABEL maintainer="zeyufu@bu.edu"

WORKDIR /upspin

COPY --from=build /go/bin/* ./
ADD start.sh ./
RUN mkdir cert

RUN openssl genrsa -out cert/rootCA.key.pem 4096
RUN openssl req -x509 -new -nodes -key cert/rootCA.key.pem \
    -sha256 -days 1024 -subj "/C=US/ST=MA/O=IaC/CN=IaC_Root_CA" \
    -out /etc/ssl/certs/rootCA.crt.pem
RUN openssl genrsa -out cert/server.key.pem 2048
RUN openssl req -new -sha256 \
    -key cert/server.key.pem \
    -subj "/C=US/ST=MA/O=IaC/CN=upspin.k-apps.osh.massopen.cloud" \
    -out cert/server.csr.pem
RUN openssl x509 -req -in cert/server.csr.pem \
    -CA /etc/ssl/certs/rootCA.crt.pem -CAkey cert/rootCA.key.pem -CAcreateserial \
    -out cert/server.crt.pem \
    -days 500 -sha256
RUN cat cert/server.crt.pem /etc/ssl/certs/rootCA.crt.pem > cert/upspin.k-apps.osh.massopen.cloud.crt.pem
RUN chmod 0644 cert/*

RUN setcap cap_net_bind_service=+ep upspinserver

VOLUME "/upspin/data"
VOLUME "/upspin/cert"

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "sh", "/upspin/start.sh" ]