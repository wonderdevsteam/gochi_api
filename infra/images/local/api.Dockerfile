FROM mcr.microsoft.com/devcontainers/go:0-1.20

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install pipenv and compilation dependencies
RUN \
    apt-get update \
    && sudo apt-get install -y gnupg software-properties-common curl \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gcc zsh wget nano procps htop git zsh tree terraform \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER vscode

WORKDIR /home/vscode

ENV TERM xterm

RUN mkdir /home/vscode/commandhistory && touch /home/vscode/commandhistory/.zsh_history

WORKDIR /home/app

ENV SHELL /bin/zsh

# Install application into container
COPY . /home/app
COPY ./infra/images/local/.zshrc /home/vscode/.zshrc

CMD [ "tail", "-f", "/dev/null" ]