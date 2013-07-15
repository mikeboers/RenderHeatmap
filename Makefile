
# setenv MACOSX_DEPLOYMENT_TARGET 10.5

SHADERS := $(wildcard shaders/*.sl)
SHADER_OBJS := ${SHADERS:%.sl=%.slo}

SRCS := src/utils.cpp
OBJS := ${SRCS:src/%.cpp=build/%.o}
LIBS := lib/DebugRtx.so lib/PythonRtx.so

CFLAGS := -g -Iinclude -I$$RMANTREE/include $(shell python-config --includes)
LDFLAGS := $(shell python-config --libs)
RENDERFLAGS := 
RENDER := PYTHONPATH=$$RMANTREE/bin python render.py ${RENDERFLAGS}

TEXTURES := textures/van.jpg

.PHONY: default build shaders flat clean textures
.PRECIOUS: build/%.o

default: build

build:

shaders: ${SHADER_OBJS}

shaders/%.slo: shaders/%.sl
	shader -O2 -o $@ $<

build/%.o: src/%.cpp
	@ mkdir -p build
	g++ ${CFLAGS} -c -o $@ $<

lib/%.so: build/%.o ${OBJS}
	@ mkdir -p lib
	g++ ${LDFLAGS} -bundle -undefined dynamic_lookup -o $@ $^


ex1: build shaders textures
	@ mkdir -p out
	${RENDER} scenes/spheres.rib


clean:
	- rm -rf build
	- rm lib/*.so
	- rm shaders/*.slo
