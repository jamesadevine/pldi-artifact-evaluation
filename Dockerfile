FROM ubuntu:22.04
RUN apt update

ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y git wget curl build-essential libdbus-glib-1-dev libgirepository1.0-dev cmake udev net-tools python2

ADD scripts/install-gcc-arm-none-eabi.sh /install-gcc-arm-none-eabi.sh
RUN /install-gcc-arm-none-eabi.sh

ENV NODE_VERSION=14.17.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
RUN npm install -g yarn makecode
RUN git clone https://github.com/microsoft/pxt-jacdac --branch v1.9.25 --recursive
RUN git clone https://github.com/microsoft/jacdac-docs --branch pldi24 --recursive
RUN cd /jacdac-docs && yarn install --frozen-lockfile
RUN git clone https://github.com/tballmsft/jacdacnitelite --branch pldi24 --recursive
RUN git clone https://github.com/microsoft/jacdac-msr-modules --branch pldi24 --recursive
RUN mkdir /artifacts
RUN cd /pxt-jacdac/tools/microbit-jukebox && makecode build
RUN cp /pxt-jacdac/tools/microbit-jukebox/built/binary.hex /artifacts/microbit-jukebox.hex
RUN cd /jacdacnitelite && makecode build
RUN cp /jacdacnitelite/built/binary.hex /artifacts/jacdacnitelite.hex
RUN cd /jacdac-msr-modules && make drop
RUN cd /jacdac-msr-modules && ./pldi24.sh >> /artifacts/firmware-sizes.txt

