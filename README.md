# Docker Image and Dockerfile

A Docker image and DockerFile are provided, which automate the steps of building the artifacts mentioned below. To make most efficient use of time, we suggest using the artifacts that were automatically built from the sources (both artifacts and sources included in the Docker image). Of course, the evaluators may want to build from sources themselves - a docker file (`./Dockerfile`) and build step are provided in this case.

Docker commands:
- may require sudo on linux
- ctrl + d to exit an interactive terminal

## Loading prebuilt docker image
1. Download the prebuilt docker image `pldi_ae_container.tar.gz`
2. Open a terminal at the location where `pldi_ae_container.tar.gz` was downloaded.
3. Load the docker image: `docker load -i ./pldi_ae_container.tar.gz `

## Building Docker image (optional)

1. Download the dockerfile `Dockerfile`
2. Open a terminal at the location where `Dockerfile` was downloaded.
3. Build the docker image: `docker build --platform linux/amd64 -t pldi_ae_container .`

## Starting the container
1. Start a container: `docker run --platform linux/amd64 -id --name=pldi-ae -t pldi_ae_container:latest`

## Copying prebuilt files from the container
1. Copy prebuilt files from the container: `docker cp pldi-ae:/artifacts ./artifacts`

## Running shell in Docker
1. Start an interactive session with the docker container: `docker exec -it pldi-ae bash`

## Docker cleanup:

To purge the docker image if building from scratch or loading in a different version:
1. Stop the running container: `docker stop pldi-ae`
2. Remove the image: `docker rm pldi-ae`

# Getting Started Guide

This evaluation is unusual for PLDI as it involves [Jacdac](https://aka.ms/jacdac) hardware (now commercially available) for creating embedded/embeddable systems using a plug-and-play design.

## Jacdac hardware (supplied)

You should have received the following hardware to perform the evaluation:

   1. A micro:bit V2 "Go Bundle" (https://www.sparkfun.com/products/17288) which includes:
      - a micro:bit V2
      - battery pack
      - micro-USB cable (for connecting micro:bit to PC)

   2. KittenBot Kit A with micro:bit Jacdaptor (https://www.kittenbot.cc/products/kittenbot-jacdac-kit-for-micro-bit), which includes
      - Jacdac cables
      - 1 micro:bit Jacdaptor (a bridge between micro:bit and Jacdac bus)
      - 2 keycap button modules
      - 1 slider (potentiometer) module
      - 1 rotary encoder module
      - 1 light sensor module
      - 1 magnetic field sensor module
      - 1 LED ring module
      - 1 passive Jacdac hub

   3. a turtle-shaped MSR accelerometer module (https://microsoft.github.io/jacdac-docs/devices/microsoft-research/jmaccelerometer30v10/)

We have flashed the micro:bit you have received with the "microbit-jukebox" app, a MakeCode application that demonstrates the plug-and-play capability of Jacdac; we will give instructions on how to build the application yourself as well.

NOTE: Figure 1(a) of the paper shows some Jacdac modules that are in Kit B from KittenBot (https://www.kittenbot.cc/products/jacdac-kit-b-elite-module-suite-redefining-electronic-interfacing), which we did not include in the hardware above. We included the hardware needed for the running example ``night light'' featured in the paper.

## Evaluation overview

The evaluation consists of five parts:
   1. Work with pre-programmed micro:bit and Jacdac hardware
   2. Work with the Jacdac web site
   3. Deploy and work with "night light" exampe from paper (HW and SW)
   4. Check the automatically generate stats that go into Table 1 and 2.
   5. OPTIONAL: examine full sources of various figures in the table

There are optional steps to repeat the steps to build artifacts from sources.

# Step-by-Step Instructions

## 1. Work with the pre-programmed micro:bit and Jacdac hardware
   - Power micro:bit via battery pack, plugged into JST port on the micro:bit
   - Plug the micro:bit into jacdac adaptor, make sure the small switch in the middle of the jacdac adaptor is in jacdac (lower) position, providing power to Jacdac bus from micro:bit
   - Attach keycap button module via cable to adaptor, see count go up, micro:bit screen react
   - Try another button
   - Try other modules, like slider, light sensor, etc.
   - Try removing something from Jacdac bus, see count go down
   - See https://microsoft.github.io/jacdac-docs/start/ for videos and more information about the microbit-jukebox app.
   - OPTIONAL: Build the microbit-jukebox app from sources using the MakeCode CLI and copy over USB to micro:bit.
      - The built app (hex file to be copied to micro:bit) already is available in **artifacts/microbit-jukebox.hex**
      - to build yourself:
      ``````
         docker exec -it pldi-ae bash
         cd /pxt-jacdac/tools/microbit-jukebox && makecode build
         cp /pxt-jacdac/tools/microbit-jukebox/built/binary.hex /artifacts/microbit-jukebox.hex
         exit
         docker cp pldi-ae:/artifacts ./artifacts
      ``````

      -   copy artifacts/microbit-jukebox.hex to micro:bit drive (plugged into computer via USB cable)

## 2. Work with the Jacdac web site
   - Open https://aka.ms/jacdac
   - attach micro:bit to computer via USB
   - press the connect button in the Jacdac web site (and see the various modules connected to the micro:bit (from step 1) displayed in the dashboard)
   - see that changes to hardware state are reflected in the digital twins
   - open device tree view (from wrench on upper left) and inspect devices and services on the Jacdac bus

   - OPTIONAL: building Jacdac web site from sources
     - See https://github.com/microsoft/jacdac-docs
     - We found too many issues in getting the web site to run under Docker

## 3. Deploy and work with the "night light" example
   - The "night light" example uses the following hardware components:
      - micro:bit V2
      - Jacdaptor
      - battery pack (optional, as power can be supplied over USB as well)
      - slider module
      - light sensor module
      - accelerometer module
      - LED ring module
   - Configure the hardware as shown in Figure 1(b); note that the order of the four modules is not important:
     - accelerometer module
     - light level module
     - LED ring module
     - slider module
   - attach micro:bit via USB cable to computer
   - copy **artifact/nightlight.hex** to micro:bit drive
   - experiment as in paper
      - turn accelerometer face down to active night light logic (check mark on 5x5)
      - put light sensor in fist and hold tightly
      - see how slider affects brightness of LED ring

   - OPTIONAL build "night light" program from sources using MakeCode CLI

   ``````
      docker exec -it pldi-ae bash
      cd /jacdacnitelite && makecode build
      cp /jacdacnitelite/built/binary.hex /artifacts/nightlight.hex
      exit docker
      docker cp pldi-ae:/artifacts ./artifacts
   ``````

      - copy artifacts/nightlight.hex to micro:bit drive (plugged into computer via USB cable)

   - OPTIONAL (Figure 3) load the project into https://makecode.microbit.org/ as follows
      - go to https://makecode.microbit.org/
      - press "Import" button on right side of home screen
      - select "Import URL" option and enter https://github.com/tballmsft/jacdacnitelite
      - connect micro:bit to computer via USB cable
      - click ... next to Download button in lower-left of MakeCode and connect MakeCode to the micro:bit via WebUSB
      - reset the micro:bit (press button on back)
      - see device twins for connected modules (as in dashboard)

## 4. Inspect .tex for Tables 1 and 2 generate automatically by analysis of firmware object files.
   - The generated tables are at **artifacts/firmware-sizes.txt**

   - OPTIONAL: build firmware from sources and run scripts
     ``````
      docker exec -it pldi-ae bash
      cd /jacdac-msr-modules && make clean && make drop
      cd /jacdac-msr-modules && ./pldi24.sh >> /artifacts/firmware-sizes.txt
      ``````

   - OPTIONAL: to see the size of the object files for the temp/humidity sensor described in Section 5.3.1:
      ``````
      docker exec -it pldi-ae bash
      cd /jacdac-msr-modules
      make TRG=targets/jm-v4.0/profile/temphum-202.c
      make TRG=targets/jm-v4.0/profile/temphum-202.c  st|grep FLASH| sort
      ``````

## 5. OPTIONAL: inspect sources of various Figures in paper
   - Figure 2
      - https://microsoft.github.io/jacdac-docs/services/accelerometer/
      - https://github.com/microsoft/jacdac/blob/main/services/accelerometer.md
   - Figure 6
      - https://microsoft.github.io/jacdac-docs/services/distance/
      - https://github.com/microsoft/jacdac/blob/main/services/distance.md
   - Figure 7
      - https://microsoft.github.io/jacdac-docs/services/led/
      - https://github.com/microsoft/jacdac/blob/main/services/led.md
   - Figure 8
      - https://github.com/microsoft/jacdac-c/blob/main/inc/jd_physical.h
   - Figure 9
      - https://github.com/microsoft/jacdac/blob/main/services/buzzer.md
      - https://github.com/microsoft/jacdac-c/blob/main/services/buzzer.c
      - https://github.com/microsoft/jacdac-msr-modules/blob/main/targets/jm-v4.0/profile/buzzer-89.c




