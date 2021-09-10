FROM nvidia/cuda:11.4.1-devel-ubuntu20.04
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends python3-pip git curl wget sudo build-essential apt-transport-https lsb-release gnupg 
    # && curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && az extension add --name azure-cli-ml
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
    && apt-get update && apt-get -y install --no-install-recommend azure-cli
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY . /tmp/ctx/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/ctx/requirements.txt
