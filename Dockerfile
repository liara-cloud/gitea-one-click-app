FROM alpine:3.12

ARG GITEA_VERSION

RUN apk --no-cache add \
    bash \
    ca-certificates \
    openssh-keygen \
    gettext \
    git \
    curl \
    gnupg

RUN mkdir /data && cd /data \
  && wget -O gitea.bin https://dl.gitea.io/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64 \
  && chmod +x gitea.bin \ 
  && mkdir -p /data/gitea/custom \
  && mkdir -p /data/gitea/data \
  && mkdir -p /data/gitea/log \
  && mkdir /etc/gitea \
  && chmod 770 /etc/gitea \
  && cp gitea.bin /usr/local/bin/

RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /tmp/gitea/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git

COPY app.ini /data/
COPY setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

ENV RUN_MODE "prod"
ENV GITEA_WORK_DIR /data/gitea/

RUN chown -R git:git /data/

#git:git
USER 1000:1000

CMD [ "/usr/local/bin/setup.sh" ]
