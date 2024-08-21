FROM alpine:latest as build
RUN apk add --no-cache build-base automake autoconf pkgconf
WORKDIR /build
ADD ngircd /build
ADD eris.patch /build
RUN patch -p1 <eris.patch
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

FROM alpine:latest
COPY --from=build /usr/local/sbin/ngircd /usr/local/bin
ADD minimal.conf /usr/local/etc/ngircd.conf
EXPOSE 6667/tcp
CMD ["ngircd", "-n"]
