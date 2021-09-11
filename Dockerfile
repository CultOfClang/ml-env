FROM nvidia/cuda:11.4.1-devel-ubuntu20.04 as base

ARG PACKAGES="apt-utils \
        openssh-client \
        gnupg2 \
        iproute2 \
        procps \
        lsof \
        htop \
        net-tools \
        psmisc \
        curl \
        wget \
        rsync \
        ca-certificates \
        unzip \
        zip \
        nano \
        vim-tiny \
        less \
        jq \
        lsb-release \
        apt-transport-https \
        dialog \
        libc6 \
        libgcc1 \
        libkrb5-3 \
        libgssapi-krb5-2 \
        libicu[0-9][0-9] \
        liblttng-ust0 \
        libstdc++6 \
        zlib1g \
        locales \
        sudo \
        ncdu \
        man-db \
        strace \
        manpages \
        manpages-dev \
        init-system-helpers \
        git \
        build-essential \
        python3-pip \
        python3-numpy \
        software-properties-common \
        supervisor \
        libffi-dev \
        bash \
        zsh \
        "

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends ${PACKAGES} \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && az extension add --name azure-cli-ml \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*



COPY /dist/base/requirements.txt /tmp/ctx/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/ctx/requirements.txt

RUN rm -rf /tmp/ctx/

FROM base as basic

FROM base as jupyter

ADD https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/docker-debian.sh /tmp/ctx/
RUN chmod +x /tmp/ctx/docker-debian.sh && /tmp/ctx/docker-debian.sh false
ENTRYPOINT ["/usr/local/share/docker-init.sh"]
CMD ["sleep", "infinity"]

COPY /dist/jupyter/requirements.txt /tmp/ctx/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/ctx/requirements.txt

FROM base as scikit-learn
COPY /dist/scikit-learn/requirements.txt /tmp/ctx/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/ctx/requirements.txt

FROM base as tensorflow
COPY /dist/tensorflow/requirements.txt /tmp/ctx/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/ctx/requirements.txt

FROM base as pytorch
COPY /dist/pytorch/requirements.txt /tmp/ctx/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/ctx/requirements.txt

FROM base as aio
COPY /dist/aio/requirements.txt /tmp/ctx/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/ctx/requirements.txt


# run with
# "runArgs": ["--init"],
# "mounts": [ "source=/var/run/docker.sock,target=/var/run/docker-host.sock,type=bind" ],
# "overrideCommand": false