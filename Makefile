# name of the main source file
TARGET=SN_wasp_gateway.pde

# paths
ifneq ("$(wildcard Makefile.inc)","")
  $(info Using environment overrides)
  include Makefile.inc
else
  WASP_PATH=/opt/programs/waspmote-pro/waspmote
  PORT=/dev/ttyUSB0
  BUILD_PATH=build
endif

# output file
OUT=${BUILD_PATH}/${TARGET}.elf

all: ${OUT}

${OUT}: ${TARGET}
	${WASP_PATH} --pref build.path=${BUILD_PATH} --verify ${TARGET}

flash: ${TARGET}
	${WASP_PATH} --pref build.path=${BUILD_PATH} --port ${PORT} --upload ${TARGET}

terminal:
	minicom -D ${PORT} -b 115200

format-all:
	clang-format -i ${TARGET}

clean-all:
	rm -Rf ${BUILD_PATH}
