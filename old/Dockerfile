FROM alpine:latest
RUN apk add musl-dev libretls-dev ctags make automake gcc curl git ncurses-dev byacc flex libtool sqlite-dev autoconf util-linux
COPY cans.motd /etc/motd
WORKDIR /cans
ADD . /cans

