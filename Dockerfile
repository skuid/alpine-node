FROM alpine:3.6

## `VERSION` is used if we switch to compiling node. Define `YARN_VERSION` if you want yarn installed.
# ENV VERSION=v4.8.3 NPM_VERSION=2
# ENV VERSION=v6.11.0 NPM_VERSION=3
# ENV VERSION=v7.10.0 NPM_VERSION=4 YARN_VERSION=latest
# ENV VERSION=v8.1.0 NPM_VERSION=5 YARN_VERSION=latest
ENV NPM_VERSION=4

ENV RM_DIRS="/usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /root/.gnupg /root/.cache /usr/lib/node_modules/npm/scripts"

ENV BUILD_TOOLS="binutils-gold curl gcc g++ git gnupg linux-headers make python2-dev py-pip"

RUN apk add --update --no-cache --virtual .build-tools ${BUILD_TOOLS} \
&& apk add --no-cache jq nodejs=6.10.3-r0 nodejs-npm=6.10.3-r0 python2 \
  && if [ -n "$NPM_VERSION" ]; then \
    npm install -g npm@${NPM_VERSION}; \
  fi \
  && if [ -n "$YARN_VERSION" ]; then \
    npm install -g yarn@${YARN_VERSION}; \
  fi \
  && find /usr/lib/node_modules/npm -name test -o -name .bin -o -name doc -o -name html -o -name man -type d | xargs rm -rf \
  && pip install awscli \
  && apk del .build-tools \
  && rm -rf ${RM_DIRS}
