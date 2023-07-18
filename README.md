# lapis-blog-tutorial


```
luarocks install luaossl OPENSSL_LIBDIR=/usr/local/Cellar/openssl@1.1/1.1.1t/lib OPENSSL_DIR=/usr/local/Cellar/openssl@1.1/1.1.1t/ CRYPTO_DIR=/usr/local/Cellar/openssl@1.1/1.1.1t/
luarocks install lapis
```

```
lapis new
lapis generate model user
lapis generate model post
lapis generate model comments
```

# Development

Build the image locally:

```
docker build \
    -t lapis-tutorial-blog

```

To run:

```
docker run \
    -dti \
    -v "./data:/var/data" \
    -v "./app:/var/www" \
    -e LAPIS_ENV="development" \
    -p 8080:80 \
    --name lapis-tutorial-blog \
    --platform=linux/amd64 \
    lapis-tutorial-blog
```
