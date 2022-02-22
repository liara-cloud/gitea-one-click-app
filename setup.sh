#!/bin/bash

set -e

# TODO:
# This if statement means we can't change Gitea's settings after initial setup using envs.
# But this causes some issues. Users expect to be able to change settings using envs.
# Actually this is the correct way of doing it, like WordPress one-click-app.
# So talk to Reza about it and then you might need to remove this check.
if [ ! -f ${GITEA_WORK_DIR}/custom/conf/app.ini ]; then
    mkdir -p ${GITEA_WORK_DIR}/custom/conf

    # TODO: What is this?
    # Set INSTALL_LOCK to true only if SECRET_KEY is not empty and
    # INSTALL_LOCK is empty
    if [ -n "$SECRET_KEY" ] && [ -z "$INSTALL_LOCK" ]; then
        INSTALL_LOCK=true
    fi

    # Substitude the environment variables in the template
    APP_NAME=${APP_NAME:-"Gitea: Git with a cup of tea"} \
    RUN_MODE=${RUN_MODE:-"dev"} \
    DOMAIN=${DOMAIN:-"localhost"} \
    SSH_DOMAIN=${SSH_DOMAIN:-"localhost"} \
    HTTP_PORT=${HTTP_PORT:-"3000"} \
    ROOT_URL=${ROOT_URL:-""} \
    DISABLE_SSH=${DISABLE_SSH:-"true"} \
    SSH_PORT=${SSH_PORT:-""} \
    SSH_LISTEN_PORT=${SSH_LISTEN_PORT:-"${SSH_PORT}"} \
    LFS_START_SERVER=${LFS_START_SERVER:-"false"} \
    DB_TYPE=${DB_TYPE:-"sqlite3"} \
    DB_HOST=${DB_HOST:-"localhost:3306"} \
    DB_NAME=${DB_NAME:-"gitea"} \
    DB_USER=${DB_USER:-"root"} \
    DB_PASSWD=${DB_PASSWD:-""} \
    INSTALL_LOCK=${INSTALL_LOCK:-"false"} \
    DISABLE_REGISTRATION=${DISABLE_REGISTRATION:-"false"} \
    REQUIRE_SIGNIN_VIEW=${REQUIRE_SIGNIN_VIEW:-"false"} \
    SECRET_KEY=${SECRET_KEY:-""} \
    envsubst < /data/app.ini > ${GITEA_WORK_DIR}/custom/conf/app.ini
fi

chmod -R 750 /data/gitea/

mkdir /tmp/.ssh-dest

gitea.bin -c ${GITEA_WORK_DIR}/custom/conf/app.ini
