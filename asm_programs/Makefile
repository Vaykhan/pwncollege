ASM = as
LNK = ld

COMMON = build/itoa.o build/atoi.o

.PHONY: all clean

all: bin/printf bin/calc bin/sum

bin/printf: build/printf.o $(COMMON) | bin
	$(LNK) -o $@ $^

bin/calc: build/calc.o $(COMMON) | bin
	$(LNK) -o $@ $^

bin/sum: build/sum.o $(COMMON) | bin
	$(LNK) -o $@ $^

vpath %.s printf calc sum tools

build/%.o: %.s | build
	$(ASM) -o $@ $<

build:
	mkdir -p $@

bin:
	mkdir -p $@

clean:
	rm -rf build bin
