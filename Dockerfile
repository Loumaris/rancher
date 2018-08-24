FROM alpine

WORKDIR /app

ENV CLI_VERSION 2.0.4
ENV KUBE_VERSION 1.11.2

ADD https://github.com/rancher/cli/releases/download/v${CLI_VERSION}/rancher-linux-amd64-v${CLI_VERSION}.tar.gz cli.tar.gz

ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl /bin/

RUN tar -xf cli.tar.gz && \
    mv rancher-v${CLI_VERSION}/rancher /bin/ && \
    rm -f cli.tar.gz

ADD deploy.sh .

RUN chmod a+x ./deploy.sh && \
    chmod a+x /bin/kubectl

CMD ["/app/deploy.sh"]