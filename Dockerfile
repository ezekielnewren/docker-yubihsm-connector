FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y dumb-init curl libpcsclite1 libusb-1.0-0 libedit2

RUN mkdir -p /root/dump
WORKDIR /root/dump
RUN curl https://developers.yubico.com/YubiHSM2/Releases/yubihsm2-sdk-2022-06-ubuntu2204-amd64.tar.gz | tar -zxf -
WORKDIR /root/dump/yubihsm2-sdk
RUN dpkg -i $(ls -1 *.deb | grep -v libykhsmauth-dev_2.3.2_amd64.deb)
RUN rm -rf /root/dump

ENTRYPOINT ["dumb-init", "--", "bash", "-c"]
CMD ["yubihsm-connector --listen 0.0.0.0:3263"]
