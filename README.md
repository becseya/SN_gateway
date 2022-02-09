# Sensor Networks - Project 2 - Gateway

## Usage
- Download Waspmode IDE from https://downloads.libelium.com/waspmote-pro-ide-v06.28-linux64.zip
- Unzip to `/opt/programs/waspmote-pro` (or use `Makefile.inc` to specify your own path)
- Call `make flash` to compile and upload your program

## Using printf

- Find the following file inside Waspmode IDE folder: `hardware/waspmote/avr/platform.txt`
- Append `-Wl,-u,vfscanf -lscanf_flt -Wl,-u,vfprintf -lprintf_flt -lm` to the key `recipe.c.combine.pattern`

Ref: https://forum.arduino.cc/t/no-sprintf-float-formatting-come-back-five-year/331790/4
     https://forum.arduino.cc/t/problem-parsing-floats-with-sscanf/53981/3
