#!/usr/bin/env bash
set -e
set -o pipefail
set -o xtrace

eval $(luarocks --lua-version=5.1 path)
luarocks --lua-version=5.1 make /blog-dev-1.rockspec

# add openresty
export LUA_PATH="$LUA_PATH;/usr/local/openresty/lualib/?.lua"

lapis server ${LAPIS_ENV}
