FROM alpine:3.6

## `VERSION` is used if we switch to compiling node. Define `YARN_VERSION` if you want yarn installed.
# ENV VERSION=v4.8.3 NPM_VERSION=2
# ENV VERSION=v6.11.0 NPM_VERSION=3
# ENV VERSION=v7.10.0 NPM_VERSION=4 YARN_VERSION=latest
# ENV VERSION=v8.1.0 NPM_VERSION=5 YARN_VERSION=latest
ENV NPM_VERSION=4

# For base builds
#ENV CONFIG_FLAGS="--fully-static --without-npm" DEL_PKGS="libstdc++" RM_DIRS=/usr/include
ENV CONFIG_FLAGS="--fully-static" DEL_PKGS="python2-dev py-pip" RM_DIRS=""

RUN apk add --update --no-cache curl make gcc g++ git nodejs=6.10.3-r0 nodejs-npm=6.10.3-r0 python2 python2-dev py-pip linux-headers binutils-gold gnupg libstdc++ \
  && npm install -g npm@${NPM_VERSION} \
  && find /usr/lib/node_modules/npm -name test -o -name .bin -o -name doc -o -name html -o -name man -type d | xargs rm -rf \
  && if [ -n "$YARN_VERSION" ]; then \
    npm install -g yarn@${YARN_VERSION}; \
  fi \
  && pip install awscli \
  && apk del ${DEL_PKGS} \
  && rm -rf ${RM_DIRS} /usr/share/man /tmp/* /var/cache/apk/* \
    /root/.npm /root/.node-gyp /root/.gnupg /root/.cache \
    /usr/lib/node_modules/npm/scripts
