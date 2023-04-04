# Liara's Gitea One Click App

This is the Docker image used for gitea one-click app in Liara.

## How run it in development

```bash
docker build -t liaracloud/gitea-one-click-app:v1.19.0 --build-arg GITEA_VERSION=1.19.0 .

# Make sure previous container is removed
docker rm -f gitea-one-click-app
# Make sure previous volume is removed
docker volume rm gitea-one-click-app-data

docker run --name gitea-one-click-app \
           -v gitea-one-click-app-data:/data \
           -p 3000:3000 --read-only \
           --tmpfs /run --tmpfs /tmp \
           -e USER_UID=1000 -e USER_GID=1000 \
           liaracloud/gitea-one-click-app:v1.19.0
```
