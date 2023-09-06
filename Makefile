TARGET_EXEC = Game 
CC = clang++

SRC = $(wildcard src/*.cpp) $(wildcard src/**/*.cpp) $(wildcard src/**/**/*.cpp) $(wildcard src/**/**/**/*.cpp)
OBJ = $(SRC:.cpp=.o)
BIN = bin
LIBS = lib/engine/bin/libRenderer.a lib/engine/lib/bgfx/.build/linux64_gcc/bin/libbgfxDebug.a lib/engine/lib/bgfx/.build/linux64_gcc/bin/libbxDebug.a lib/engine/lib/bgfx/.build/linux64_gcc/bin/libbimgDebug.a lib/engine/lib/bgfx/.build/linux64_gcc/bin/libbimg_decodeDebug.a lib/engine/lib/glfw/build/src/libglfw3.a -lGL -lX11 -lpthread -ldl -lrt
SHADERS_DIR = resources/shaders
ENGINE_DIR = lib/engine

INC_DIR_SRC = -Isrc 
INC_DIR_LIB = -Ilib/engine/include/engine -Ilib/engine/include -Ilib/engine/lib/bgfx/include -Ilib/engine/lib/bimg/include -Ilib/engine/lib/bx/include -Ilib/engine/lib/glfw/include -Ilib/engine/lib/engine/lib/OBJ-Loader/include -Ilib/engine/lib/glm -Ilib/engine/lib

DEBUGFLAGS = $(INC_DIR_SRC) $(INC_DIR_LIB) -Wall -g -DDEBUG=1 -DBX_CONFIG_DEBUG=1
RELEASEFLAGS = $(INC_DIR_SRC) $(INC_DIR_LIB) -O2 -DDEBUG=1 -DBX_CONFIG_DEBUG=0
ASMFLAGS = $(INC_DIR_SRC) $(INC_DIR_LIBS) -Wall
LDFLAGS = $(LIBS) -lm -fuse-ld=mold 

.PHONY: all libs clean test

all: clean dirs shaders engine headers
	$(MAKE) -j16 bld
	$(MAKE) link

dirs:
	mkdir -p ./$(BIN)

link: $(OBJ)
	$(CC) -o $(BIN)/$(TARGET_EXEC) $^ $(LDFLAGS)

bld: 
	$(MAKE) obj

obj: $(OBJ)

%.o: %.cpp
	$(CC) -std=c++20 -o $@ -c $^ $(DEBUGFLAGS)

build: dirs link

run:
	./$(BIN)/$(TARGET_EXEC) 

engine:
	make -C $(ENGINE_DIR)

headers:
	make -C $(ENGINE_DIR) headers

shaders:
	make -C $(SHADERS_DIR) 

clean:
	make -C $(SHADERS_DIR) clean
	make -C $(ENGINE_DIR) clean
	rm -rf $(BIN) $(OBJ)
	clear

