LIB_ANTLR := lib/antlr.jar
ANTLR_SCRIPT := Micro.g

all: group compiler

group:
	@echo "Renju Liu(liu396); Hongbo Yang(yang716)"
compiler:
	rm -rf build
	mkdir build
	java -cp $(LIB_ANTLR) org.antlr.Tool -o build $(ANTLR_SCRIPT)
	rm -rf classes
	mkdir classes
	javac -cp $(LIB_ANTLR) -d classes src/*.java build/*.java
clean:
	rm -rf classes build

.PHONY: all group compiler clean
