FROM httpd:alpine

ENV OPENIDC_VERSION="2.1.2"
ENV CJOSE_VERSION="0.4.1"

RUN apk add --no-cache --virtual mod-auth-openidc-runtime-deps libcurl jansson pcre && \
    apk add --no-cache --virtual mod-auth-openidc-dev-deps curl curl-dev jansson-dev gcc libc-dev pcre-dev make && \
    cd /tmp && \
    curl -L --output cjose-${CJOSE_VERSION}.tar.gz https://github.com/cisco/cjose/archive/${CJOSE_VERSION=}.tar.gz && \
    curl -L --output mod_auth_openidc-${OPENIDC_VERSION}tar.gz https://github.com/pingidentity/mod_auth_openidc/releases/download/v${OPENIDC_VERSION}/mod_auth_openidc-${OPENIDC_VERSION}.tar.gz && \
    tar zxvf cjose-${CJOSE_VERSION}.tar.gz && \
    cd cjose-${CJOSE_VERSION}/ && \
    ./configure && make && make install && cd ../ && \
    tar zxvf mod_auth_openidc-${OPENIDC_VERSION}tar.gz && \
    cd mod_auth_openidc-${OPENIDC_VERSION}/ && \
    CJOSE_CFLAGS="-I/tmp/cjose-${CJOSE_VERSION}/include" CJOSE_LIBS="-L/tmp/cjose-${CJOSE_VERSION}/src/.libs -lcjose" ./configure --with-apxs2=/usr/local/apache2/bin/apxs && \
    make && make install && cd ../ && \
    apk del --no-cache mod-auth-openidc-dev-deps && \
    rm -rf /tmp/*

COPY conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY assets/* /usr/local/apache2/htdocs/

COPY httpd-foreground /usr/local/bin/
