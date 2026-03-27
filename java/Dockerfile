FROM ubuntu:24.04

LABEL author="Stepan Fedotov <stepan@wisp.gg>" maintainer="William Venner <william.venner@infraly.co>"
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update -y && \
    apt-get install -y tzdata curl wget ca-certificates software-properties-common apt-transport-https fontconfig locales openssl git tar sqlite3 iproute2 python3 && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update -y && \
    apt-get install -y openjdk-11-jre openjdk-17-jre openjdk-21-jdk openjdk-25-jdk && \
    rm -rf /var/lib/apt/lists/*

# Install Java 8, 16, 19 from Adoptium (not available in Ubuntu 24.04 repos)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then ADOPT_ARCH="x64"; else ADOPT_ARCH="aarch64"; fi && \
    curl -sL "https://api.adoptium.net/v3/binary/latest/8/ga/linux/${ADOPT_ARCH}/jre/hotspot/normal/eclipse" -o /tmp/java8.tar.gz && \
    mkdir -p /usr/lib/jvm/temurin-8 && \
    tar -xzf /tmp/java8.tar.gz -C /usr/lib/jvm/temurin-8 --strip-components=1 && \
    curl -sL "https://api.adoptium.net/v3/binary/latest/16/ga/linux/${ADOPT_ARCH}/jdk/hotspot/normal/eclipse" -o /tmp/java16.tar.gz && \
    mkdir -p /usr/lib/jvm/temurin-16 && \
    tar -xzf /tmp/java16.tar.gz -C /usr/lib/jvm/temurin-16 --strip-components=1 && \
    curl -sL "https://api.adoptium.net/v3/binary/latest/19/ga/linux/${ADOPT_ARCH}/jdk/hotspot/normal/eclipse" -o /tmp/java19.tar.gz && \
    mkdir -p /usr/lib/jvm/temurin-19 && \
    tar -xzf /tmp/java19.tar.gz -C /usr/lib/jvm/temurin-19 --strip-components=1 && \
    rm -f /tmp/java*.tar.gz

RUN ln -s /usr/lib/jvm/temurin-8/bin/java /usr/local/bin/java8 && \
    ln -s /usr/lib/jvm/java-11-openjdk-$(dpkg --print-architecture)/bin/java /usr/local/bin/java11 && \
    ln -s /usr/lib/jvm/temurin-16/bin/java /usr/local/bin/java16 && \
    ln -s /usr/lib/jvm/java-17-openjdk-$(dpkg --print-architecture)/bin/java /usr/local/bin/java17 && \
    ln -s /usr/lib/jvm/temurin-19/bin/java /usr/local/bin/java19 && \
    ln -s /usr/lib/jvm/java-21-openjdk-$(dpkg --print-architecture)/bin/java /usr/local/bin/java21 && \
    ln -s /usr/lib/jvm/java-25-openjdk-$(dpkg --print-architecture)/bin/java /usr/local/bin/java25 && \
    useradd -d /home/container -m container

USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container

COPY ./prompt.py /prompt.py
COPY ./entrypoint.sh /entrypoint.sh
CMD [ "/bin/bash", "/entrypoint.sh" ]
