FROM ubuntu:22.04
RUN apt update

ENV TZ=Europe
ENV NODE_VERSION=14.17.0

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y git wget curl build-essential libdbus-glib-1-dev libgirepository1.0-dev cmake udev net-tools python2

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

ADD scripts/install-gcc-arm-none-eabi.sh /install-gcc-arm-none-eabi.sh
RUN chmod u+x /install-gcc-arm-none-eabi.sh

ADD scripts/gcc-arm-none-eabi-10.3-2021.10-9.deb /gcc-arm-none-eabi-10.3-2021.10-9.deb
RUN dpkg -i /gcc-arm-none-eabi-10.3-2021.10-9.deb

RUN useradd -ms /bin/bash reviewer
USER reviewer
WORKDIR /home/reviewer

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR=/home/reviewer/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/home/reviewer/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
RUN npm install -g yarn makecode

RUN git clone https://github.com/microsoft/jacdac-msr-modules --branch pldi24 --recursive
RUN cd jacdac-msr-modules && make drop

RUN git clone https://github.com/microsoft/jacdac-docs --branch pldi24 --recursive
RUN cd jacdac-docs && yarn install --frozen-lockfile --network-timeout 1000000

RUN git clone https://github.com/microsoft/pxt-jacdac --branch v1.9.25 --recursive
RUN cd pxt-jacdac/tools/microbit-jukebox && makecode build

RUN git clone https://github.com/tballmsft/jacdacnitelite --branch pldi24 --recursive
RUN cd jacdacnitelite && makecode build



RUN mkdir artifacts
RUN cp pxt-jacdac/tools/microbit-jukebox/built/binary.hex artifacts/microbit-jukebox.hex
RUN cp jacdacnitelite/built/binary.hex artifacts/nightlight.hex
RUN cd jacdac-msr-modules && ./pldi24.sh >> /home/reviewer/artifacts/firmware-sizes.txt
