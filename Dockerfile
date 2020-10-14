FROM alpine:3.12

RUN apk add --no-cache git bash gettext 

RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    --home /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git && \
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

RUN mkdir /data && cd /data \
  && wget -O gitea.bin https://dl.gitea.io/gitea/1.12.5/gitea-1.12.5-linux-amd64 \
  && chmod +x gitea.bin \ 
  && mkdir -p /data/gitea/custom \
  && mkdir -p /data/gitea/data \
  && mkdir -p /data/gitea/log \
  && chown -R git:git /data/gitea/ \
  && chmod -R 750 /data/gitea/ \
  && mkdir /etc/gitea \
  && chown root:git /etc/gitea \
  && chmod 770 /etc/gitea \
  && cp gitea.bin /usr/local/bin/

COPY app.ini /data/
COPY setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

RUN touch /tmp/.git.l \
  && ln -s /tmp/.git.l /root/.gitconfig

ENV RUN_MODE "prod"
ENV GITEA_WORK_DIR /data/gitea/

CMD [ "/usr/local/bin/setup.sh" ]
