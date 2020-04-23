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
    -sha256 -days 1024 -subj "/C=US/ST=MA/O=BU" -out cert/rootCA.crt
RUN openssl genrsa -out cert/upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.key 2048
RUN openssl req -new -sha256 \
    -key cert/upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.key \
    -subj "/C=US/ST=MA/O=BU" \
    -out cert/upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.csr
RUN openssl x509 -req -in cert/upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.csr \
    -CA cert/rootCA.crt -CAkey cert/rootCA.key -CAcreateserial \
    -out cert/upspin-openshift-infrastructure-as-code.k-apps.osh.massopen.cloud.crt \
    -days 500 -sha256

VOLUME "/upspin/data"
VOLUME "/upspin/cert"

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "sh", "/upspin/start.sh" ]