FROM debian:stable-slim as build
RUN apt update && apt install -y build-essential pkgconf automake autotools-dev libident-dev
WORKDIR /build
ADD ngircd /build
ADD *.patch /build/
RUN cat *.patch | patch -p1
RUN ./autogen.sh
RUN ./configure --enable-ipv6 --with-ident --with-iconv --with-syslog
RUN make
RUN make install

FROM debian:stable-slim
COPY --from=build /usr/local/sbin/ngircd /usr/local/bin
COPY --from=build /usr/local/share/doc/ngircd/Commands.txt /usr/local/share/doc/ngircd/
COPY --from=build /usr/lib/*/libident.so* /usr/lib/
ADD minimal.conf /usr/local/etc/ngircd.conf
ADD README /usr/local/etc/ngircd.motd
EXPOSE 6667/tcp
CMD ["ngircd", "-n"]
