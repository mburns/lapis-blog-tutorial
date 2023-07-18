FROM archlinux:latest

RUN pacman -Sy base-devel lua51 sqlite luarocks redis geoip libmaxminddb tup git openssl-1.1 --noconfirm && \
	(yes | pacman -Scc || :)

# setup openresty
ARG OPENRESTY_VERSION="1.21.4.2rc1"
RUN curl -O https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
	tar xvfz openresty-${OPENRESTY_VERSION}.tar.gz && \
	(cd openresty-${OPENRESTY_VERSION} && ./configure --with-pcre-jit --with-cc-opt="-I/usr/include/openssl-1.1" --with-ld-opt="-L/usr/lib/openssl-1.1" && make && make install) && \
	rm -rf openresty-${OPENRESTY_VERSION} && rm openresty-${OPENRESTY_VERSION}.tar.gz

# Build Args
ARG OPENSSL_DIR="/usr/local/openresty/openssl"

# Environment
ENV LAPIS_ENV="development"

# Prepare volumes
VOLUME /var/data
VOLUME /var/www

RUN eval $(luarocks --lua-version=5.1 path)
RUN export LUA_PATH="$LUA_PATH;/usr/local/openresty/lualib/?.lua"

# install lua dependencies
COPY blog-dev-1.rockspec /
RUN luarocks --lua-version=5.1 build --tree "$HOME/.luarocks" --only-deps /blog-dev-1.rockspec

# Entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Standard web port (use a reverse proxy for SSL)
EXPOSE 80

WORKDIR /var/www

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
