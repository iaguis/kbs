FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl gnupg2

RUN curl -L https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -
RUN echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu focal main' > /etc/apt/sources.list.d/intel-sgx.list
RUN apt-get update && apt-get install -y \
    libsgx-dcap-default-qpl \
    libsgx-dcap-quote-verify \
    libsgx-urts \
    libtdx-attest \
    clang \
    protobuf-compiler

# install go 1.21.2
RUN curl --silent -LO "https://dl.google.com/go/go1.21.2.linux-amd64.tar.gz"
RUN tar -C /usr/local -xzf go1.21.2.linux-amd64.tar.gz
RUN ln -sf /usr/local/go/bin/go /usr/local/bin/go

COPY sgx_default_qcnl.conf /etc/sgx_default_qcnl.conf

ENV KBS_REPO_PATH=/opt/confidential-containers/kbs/repository
COPY ./kbs /usr/local/bin/kbs
CMD ["/usr/local/bin/kbs"]
