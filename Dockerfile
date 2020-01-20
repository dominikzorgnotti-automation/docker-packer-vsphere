FROM alpine

ARG PACKER_VERSION=1.4.5
ARG VSPHERE_VERSION=2.3

RUN apk update
RUN apk add ca-certificates wget jq
RUN update-ca-certificates
RUN wget -nv https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -O packer.zip
RUN mkdir /out
RUN unzip packer.zip -d /out/
RUN wget -nv https://github.com/jetbrains-infra/packer-builder-vsphere/releases/download/v${VSPHERE_VERSION}/packer-builder-vsphere-iso.linux -O /out/packer-builder-vsphere-iso.linux
RUN wget -nv https://github.com/jetbrains-infra/packer-builder-vsphere/releases/download/v${VSPHERE_VERSION}/packer-builder-vsphere-clone.linux -O /out/packer-builder-vsphere-clone.linux
RUN chmod +x /out/*

FROM alpine
COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=0 /out/* /usr/local/bin/
CMD ["/bin/sh"]
