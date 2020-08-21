FROM ubuntu:bionic
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN adduser tezos && \
    adduser tezos sudo && \
    su - tezos
RUN apt-get install -y build-essential git m4 unzip apt-utils rsync curl libev-dev libgmp-dev pkg-config libhidapi-dev

RUN apt-get install -y wget libcap2
RUN wget http://security.ubuntu.com/ubuntu/pool/universe/b/bubblewrap/bubblewrap_0.2.1-1_amd64.deb
RUN dpkg -i ./bubblewrap_0.2.1-1_amd64.deb

#RUN wget -O carthagenet.sh https://gitlab.com/tezos/tezos/raw/latest-release/scripts/tezos-docker-manager.sh
#RUN chmod +x carthagenet.sh && \
#    ./carthagenet.sh start

RUN git clone https://gitlab.com/tezos/tezos.git && \
    cd tezos
RUN git checkout latest-release

RUN sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
RUN mv opam-* /usr/local/bin/opam
RUN opam init --bare && \
    chmod a+x /usr/local/bin/opam 
RUN opam update

RUN make build-deps && \
    eval $(opam env) && \
    make
ENV PATH=~/tezos:$PATH
RUN source ./src/bin_client/bash-completion.sh
ENV TEZOS_CLIENT_UNSAFE_DISABLE_DISCLAIMER=Y

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

