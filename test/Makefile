
trig ?= 100

ALL := $(shell awk '{print$$1}' ../versions.txt)
ALL := $(filter-out gibuu,$(ALL))

default:
	@echo Run \"make all\" to test all generators.
	@echo Or specify the generator\'s name as a target, one of:
	@echo $(ALL) gibuu

all: $(ALL)

$(ALL):
	$@ --trig $(trig) --docker

gibuu:
	gibuu --trig $(trig) --docker --targ D --ebeam 11.0 --kt 0.5  

clean:
	rm -rf $(addsuffix *,$(ALL))
	rm -rf *.dat *.root *.run
	rm -rf RNDM* PYR* GiBUU* initHi* README*txt

