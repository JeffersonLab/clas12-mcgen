
trig ?= 100

define test_header
	@echo ''
	@echo '[++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++]'
	@echo " TEST $(1)"
	@echo '[++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++]'
endef

ALL := $(shell awk '{print$$1}' ../versions.txt)
ALL := $(filter-out gibuu,$(ALL))

default:
	@echo Run \"make all\" to test all generators.
	@echo Or specify the generator\'s name as a target, one of:
	@echo $(ALL) gibuu

all: $(ALL)

$(ALL):
	@$(call test_header,$@)
	$@ --trig $(trig) --docker

gibuu:
	@$(call test_header,$@)
	gibuu --trig $(trig) --docker --targ D --ebeam 11.0 --kt 0.5

clean:
	rm -rf $(addsuffix *,$(ALL))
	rm -rf *.dat *.root *.run
	rm -rf RNDM* PYR* GiBUU* initHi* README*txt

