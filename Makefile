
# setenv MACOSX_DEPLOYMENT_TARGET 10.5

SHADERS := $(wildcard shaders/*.sl)
SHADER_OBJS := ${SHADERS:%.sl=%.slo}

SRCS := 
OBJS := ${SRCS:src/%.cpp=build/%.o}
LIBS := lib/time_shadeops.so
BINS := bin/dtex_heatmap

CFLAGS := -g -Iinclude -I $$RMANTREE/include $(shell Magick++-config --cppflags --cxxflags)
LDFLAGS := -L $$RMANTREE/lib -lprman $(shell Magick++-config --ldflags --libs)
PYTHON:= PYTHONPATH=$$RMANTREE/bin python
RENDERFLAGS := 
RENDER := ${PYTHON} render.py ${RENDERFLAGS}

TEXTURES := textures/van.jpg

.PHONY: default build shaders flat clean textures
.PRECIOUS: build/%.o

default: build

build: ${BINS} ${LIBS}

shaders: ${SHADER_OBJS}
	@ mkdir -p var/shaders

shaders/%.slo: shaders/%.sl
	shader -O2 -o $@ $<

build/%.o: src/%.cpp
	@ mkdir -p build
	g++ ${CFLAGS} -c -o $@ $<


bin/%: build/%.o ${OBJS}
	@ mkdir -p bin
	g++ ${LDFLAGS} -o $@ $^
	install_name_tool -add_rpath $$RMANTREE/lib $@

lib/%.so: build/%.o ${OBJS}
	@ mkdir -p lib
	g++ ${LDFLAGS} -bundle -undefined dynamic_lookup -o $@ $^


python:
	${PYTHON}

ex1: build shaders textures
	@ mkdir -p out
	${RENDER} scenes/spheres.rib
ex1-heat: build
	bin/dtex_heatmap out/spheres-surface.dtex out/spheres-surface.tif

clean:
	- rm -rf build
	- rm -rf bin
	- rm lib/*.so
	- rm shaders/*.slo
