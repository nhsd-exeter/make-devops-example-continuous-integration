FROM python:latest as base

# ==============================================================================

FROM base as builder
ARG PYTHON_BASE_PACKAGES
ENV \
    GOSU_VERSION="1.12"

RUN set -eux && \
    \
    # Get base packages
    apk add --no-cache \
        ca-certificates \
        dpkg \
        g++ \
        gnupg \
        linux-headers \
        wget \
    && \
    # Get gosu
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    gpgconf --kill all && \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu && \
    \
    # Get Python packages
    mkdir /packages && cd /packages && \
    pip install --upgrade pip && \
    pip install --prefix=/packages --no-warn-script-location --verbose \
        $PYTHON_BASE_PACKAGES

# ==============================================================================

FROM base
ENV \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONDONTWRITEBYTECODE="1" \
    PYTHONUNBUFFERED="1" \
    SYSTEM_USER_GID="999" \
    SYSTEM_USER_UID="999" \
    SYSTEM_USER="tools" \
    TZ="Europe/London"

COPY --from=builder /usr/local/bin/gosu /usr/local/bin/gosu
COPY --from=builder /packages /usr/local
COPY assets/ /
RUN set -eux && \
    \
    # Install base packages
    apk add --no-cache \
        bash \
        bind-tools \
        ca-certificates \
        curl \
        git \
        gnupg \
        graphviz \
        iputils \
        make \
        msttcorefonts-installer \
        net-tools \
        netcat-openbsd \
        wget \
    && \
    update-ms-fonts && \
    \
    # Install aws-iam-authenticator
    curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.18.8/2020-09-18/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator && \
    \
    # Install jq
    curl -LO https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x ./jq-linux64 && \
    mv ./jq-linux64 /usr/local/bin/jq && \
    \
    # Install yq
    curl -LO https://github.com/mikefarah/yq/releases/download/3.4.0/yq_linux_amd64 && \
    chmod +x ./yq_linux_amd64 && \
    mv ./yq_linux_amd64 /usr/local/bin/yq && \
    \
    # Install kubectl
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.3/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    \
    # Configure system user
    ( deluser $SYSTEM_USER ||: ) && ( delgroup $SYSTEM_USER ||: ) && ( delgroup $(getent group $SYSTEM_USER_GID | sed -e "s/:x:$SYSTEM_USER_GID//g") ||: ) && \
    addgroup -S -g $SYSTEM_USER_GID $SYSTEM_USER && \
    adduser -H -D -s /bin/false -g "" -h /tmp -G $SYSTEM_USER -u $SYSTEM_USER_UID $SYSTEM_USER && \
    gosu nobody true

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
