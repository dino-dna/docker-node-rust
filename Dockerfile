FROM centos:centos7

USER root

ENV CARGO_HOME /home/node/.cargo
ENV RUSTUP_HOME /home/node/.rustup

RUN yum -y update && yum clean all
RUN yum -y install git make gcc gcc-c++ libgcc curl openssl openssl-devel ca-certificates tar nodejs which && yum clean all

ENV SSL_VERSION=1.0.2k

RUN curl https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz -O && \
    tar -xzf openssl-$SSL_VERSION.tar.gz && \
    cd openssl-$SSL_VERSION && ./config && make depend && make install && \
    cd .. && rm -rf openssl-$SSL_VERSION*

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum -y install nodejs npm; yum clean all

ENV OPENSSL_LIB_DIR=/usr/local/ssl/lib \
    OPENSSL_INCLUDE_DIR=/usr/local/ssl/include \
    OPENSSL_STATIC=1

RUN useradd -ms /bin/bash node
RUN npm install -g neon-cli
USER node

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- -y && \
    echo "source home/node/.cargo/env" >> "$HOME/.bashrc" 

RUN chmod -R ugo+rw /home/node
WORKDIR /app

CMD ["bash"]
