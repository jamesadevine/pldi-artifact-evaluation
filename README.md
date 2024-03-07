# Docker Image and Dockerfile

A Docker image and DockerFile are provided, which automate the steps of building the artifacts mentioned below. To make most efficient use of time, we suggest using the artifacts that were automatically built from the sources (both included in the Docker image). Of course, the evaluators may want to do some of the steps themselves, which is possible.

 (docker operations may require sudo on linux)

 ctrl + d to exit

`docker build -t pldi_ae_container .`

`docker run -id --name=pldi-ae -t pldi_container:latest`

`docker cp pldi-ae:/artifacts ./artifacts`

`docker exec -it pldi-ae bash`

cleanup:

`docker stop pldi-ae`
`docker rm pldi-ae`

# Getting Started Guide

This evaluation is unusual for PLDI as it involves new hardware (now commercially available) for creating embedded/embeddable systems using a plug-and-play design.

## Jacdac hardware (supplied)

You should have received the following hardware to perform the evaluation:

   1. A micro:bit V2 "Go Bundle" (https://www.sparkfun.com/products/17288) which includes

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

   3. a turtle-shaped MSR accelerometer module
    - https://microsoft.github.io/jacdac-docs/devices/microsoft-research/jmaccelerometer30v10/

We have flashed the micro:bit you have received with the "microbit-jukebox" app, a MakeCode application that demonstrates the plug-and-play capability of Jacdac; we will give instructions on how to build the application yourself as well.

## Evaluation overview

The evaluation consists of three parts:
   1. Work with Jacdac hardware, using the MakeCode CLI to create a
      program that works with Jacdac

   2. Working with Jacdac web site and dashboard and build and run Jacdac 
      web site locally from sources

   3. Work with running example from paper ("nite lite")

   4. Build Jacdac firmware from sources and run 
      scripts that generate all the statistics in Table 1 and 2 of the paper

The running example in the paper ("nite lite") uses the following hardware components from above:

    - micro:bit V2
    - Jacdaptor
    - battery pack (optional, as power can be supplied over USB as well)
    - slider module
    - light sensor module
    - accelerometer module
    - LED ring module

# Step-by-Step Instructions

1. Experiment with the pre-loaded microbit-jukebox hex file to see plug-and-play in action
   - Power micro:bit via battery pack, plugged into JST port on the micro:bit
   - Plug the micro:bit into jacdac adaptor, make sure the small switch in the middle of the jacdac adaptor is in jacdac (lower) position, providing power to Jacdac bus from micro:bit
   - Attach keycap button module via cable to adaptor, see count go up, micro:bit screen react
   - Try another button 
   - Try other modules, like slider, light sensor, etc.
   - Try removing something from Jacdac bus, see count go down
   - See https://microsoft.github.io/jacdac-docs/start/ for videos and more information

    OPTIONAL: Build the microbit-jukebox app from sources using the MakeCode CLI
    and copy over USB to micro:bit. The app is available in artifacts/XYZ

2. Now open the Jacdac web site at https://aka.ms/jacdac
   - attach micro:bit to computer via USB
   - press the connect button in the Jacdac web site (and
   - see the various modules displayed in the dashboard
   - changes to hardware state reflected in the digital twins
   - open device tree view (from wrench on upper left), inspect devices and services
   OPTIONAL Build the Jacdac web site from sources and host locally
       - command to open shell in Docker
       - yarn develop (need to wait a bit until tty output stops)
       - navigate to http://localhost:8000/
       - see the same as before in (3)
    
3. Deploy and run the "nite lite" example from the paper
   - configure the hardware as shown in Figure 1(b); note that the order of the four modules is not important
     - accelerometer
     - light level sensor
     - LED ring
     - slider
   The app is availabl in artifacts/XYZ. 
   - attach micro:bit via USB
   - copy built/binary.hex to micro:bit drive
   - experiment as in paper
      - turn accelerometer face down to active nite lite logic (check mark on 5x5)
      - put light sensor in fist and hold tightly
      - see how slider affects brightness of LED ring
      - try changing color of ring with modification to code (repeat makecode build and copy steps)
    OPTIONAL build "nite lite" program from sources using MakeCode CLI
    OPTIONAL load the project into https://makecode.microbit.org/ as follows
      - go to https://makecode.microbit.org/
      - press "Import" button on right side of home screen
      - select "Import URL" option and enter https://github.com/tballmsft/jacdacnitelite

4. Inspect .tex for Tables 1 and 2 generate automatically by analysis of firmware object files.
   The artifacts are available XYZ.
   OPTIONAL: build firmware from sources and run scripts