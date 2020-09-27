FROM alpine:3.12.0

LABEL org.label-schema.name="alpine-mupdf"
LABEL maintainer.name="Oliver Guo"
LABEL maintainer.email="oli.zd.guo@gmail.com"

WORKDIR /opt

RUN mkdir data

COPY crontab.conf crontab.conf

COPY entry.sh entry.sh

COPY convert.sh convert.sh

COPY source mupdf

RUN apk add --no-cache \
        make \
        pkgconfig \
        build-base \
        && cd /opt/mupdf \
        && make HAVE_X11=no HAVE_GLUT=no prefix=/usr/local install

ENV LANG=en_HK.UTF-8

RUN crond start

RUN rm -f /var/cache/apk/*
RUN rm -rf /tmp/*

RUN chmod 777 /opt/entry.sh

ENTRYPOINT ["/opt/entry.sh"]
