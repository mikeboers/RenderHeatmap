
# setenv MACOSX_DEPLOYMENT_TARGET 10.5

SHADERS := $(wildcard shaders/*.sl)
SHADER_OBJS := ${SHADERS:%.sl=%.slo}

SRCS := 
OBJS := ${SRCS:src/%.cpp=build/%.o}
LIBS := lib/time_shadeops.so

CFLAGS := -g -Iinclude -I$$RMANTREE/include $(shell python-config --includes)
LDFLAGS := $(shell python-config --libs)
PYTHON:= PYTHONPATH=$$RMANTREE/bin python
RENDERFLAGS := 
RENDER := ${PYTHON} render.py ${RENDERFLAGS}

TEXTURES := textures/van.jpg

.PHONY: default build shaders flat clean textures
.PRECIOUS: build/%.o

default: build

build: ${LIBS}

shaders: ${SHADER_OBJS}
	@ mkdir -p var/shaders

shaders/%.slo: shaders/%.sl
	shader -O2 -o $@ $<

build/%.o: src/%.cpp
	@ mkdir -p build
	g++ ${CFLAGS} -c -o $@ $<

lib/%.so: build/%.o ${OBJS}
	@ mkdir -p lib
	g++ ${LDFLAGS} -bundle -undefined dynamic_lookup -o $@ $^


python:
	${PYTHON}

ex1: build shaders textures
	@ mkdir -p out
	${RENDER} scenes/spheres.rib


clean:
	- rm -rf build
	- rm lib/*.so
	- rm shaders/*.slo
