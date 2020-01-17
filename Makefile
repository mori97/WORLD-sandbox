gcc_options = -std=c++17 -O2 -Wall -fPIC --pedantic-error
world_dir = ./World
build_dir = ./build
objs = $(build_dir)/world/cheaptrick.o $(build_dir)/world/common.o $(build_dir)/world/d4c.o $(build_dir)/world/dio.o $(build_dir)/world/fft.o $(build_dir)/world/matlabfunctions.o $(build_dir)/world/stonemask.o $(build_dir)/world/synthesis.o $(build_dir)/world/synthesisrealtime.o $(build_dir)/world/harvest.o

all : $(build_dir)/estimate_f0

$(build_dir)/estimate_f0 : estimate_f0.cpp
	mkdir -p $(build_dir)
	g++ $(gcc_options) -I$(world_dir)/src -I$(world_dir)/tools -o $@ $^

$(build_dir)/libworld.a : $(objs)
	ar -rv $(build_dir)/libworld.a $(objs)

# Build WORLD
$(build_dir)/world/cheaptrick.o : $(world_dir)/src/world/cheaptrick.h $(world_dir)/src/world/common.h $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/common.o : $(world_dir)/src/world/common.h $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/d4c.o : $(world_dir)/src/world/d4c.h $(world_dir)/src/world/common.h $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/dio.o : $(world_dir)/src/world/dio.h $(world_dir)/src/world/common.h $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/fft.o : $(world_dir)/src/world/fft.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/matlabfunctions.o : $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/stonemask.o : $(world_dir)/src/world/stonemask.h $(world_dir)/src/world/fft.h $(world_dir)/src/world/common.h $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/synthesis.o : $(world_dir)/src/world/synthesis.h $(world_dir)/src/world/common.h $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/synthesisrealtime.o : $(world_dir)/src/world/synthesisrealtime.h $(world_dir)/src/world/common.h $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h
$(build_dir)/world/harvest.o : $(world_dir)/src/world/harvest.h $(world_dir)/src/world/common.h $(world_dir)/src/world/constantnumbers.h $(world_dir)/src/world/matlabfunctions.h $(world_dir)/src/world/macrodefinitions.h

$(build_dir)/world/%.o : $(world_dir)/src/%.cpp
	mkdir -p $(build_dir)/world
	g++ $(gcc_options) -I$(world_dir)/src -o $@ -c $<

$(build_dir)/tools/%.o : $(world_dir)/tools/%.cpp
	mkdir -p $(build_dir)/tools
	g++ $(gcc_options) -I$(world_dir)/src -o $@ -c $<

clean :
	rm -rf $(build_dir)
	rm -f ./include.h.gch

.PHONY : clean
