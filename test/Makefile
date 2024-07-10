
ALL := $(shell awk '{print$$1}' ../versions.txt)
TRIG ?= 100

default:
	@echo Run \"make all\" to test all generators.
	@echo Or specify the generator\'s name as a target, one of:
	@echo $(ALL)

all: $(ALL)

$(ALL):
	$@ --trig $(TRIG) --docker

