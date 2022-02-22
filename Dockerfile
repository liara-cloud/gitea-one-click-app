FROM alpine:3.12

ARG GITEA_VERSION

RUN apk add --no-cache git bash gettext 

RUN mkdir /data && cd /data \
  && wget -O gitea.bin https://dl.gitea.io/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64 \
  && chmod +x gitea.bin \ 
  && mkdir -p /data/gitea/custom \
  && mkdir -p /data/gitea/data \
  && mkdir -p /data/gitea/log \
  && mkdir /etc/gitea \
  && chmod 770 /etc/gitea \
  && cp gitea.bin /usr/local/bin/

COPY app.ini /data/
COPY setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

RUN touch /tmp/.git.l \
  && ln -s /tmp/.git.l /root/.gitconfig

ENV RUN_MODE "prod"
ENV GITEA_WORK_DIR /data/gitea/

RUN mkdir /tmp/.ssh-dest && ln -s /tmp/.ssh-dest /root/.ssh

CMD [ "/usr/local/bin/setup.sh" ]
