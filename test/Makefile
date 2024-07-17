
# Number of events to generate per generator:
trig ?= 100

# test the local build, i.e., set the environment via ../env.sh:
# (use "make local=0" to test whatever's in your environment already)
local ?= 1

ALL := $(shell awk '{print$$1}' ../versions.txt)
ALL := $(filter-out gibuu,$(ALL))

define test_header
	@echo ''
	@echo '[++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++]'
	@echo " TEST $(1)"
	@echo '[++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++]'
endef

help:
	@echo '[++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++]'
	@echo "                    Run 'make all' to test all generators."
	@echo "             Or specify the generator's name as a target, one of:"
	@echo
	@echo $(shell echo $(ALL) | cut -c -80) gibuu
	@echo $(shell echo $(ALL) | cut -c 81-)
	@echo
	@echo "                       There's also custom options:"
	@echo "     * local=0 to test another build, whatever is in your current environment."
	@echo "     * trig=N to set the number of triggers per generator."
	@echo "       (e.g. make dvcsgen local=0 trig=10000"
	@echo '[++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++]'

all: $(ALL)

$(ALL):
	@$(call test_header,$@)
	[ $(local) -eq 0 ] || . ../env.sh && $@ --trig $(trig) --docker

gibuu:
	@$(call test_header,$@)
	[ $(local) -eq 0 ] || . ../env.sh && $@ --trig $(trig) --docker --targ D --ebeam 11.0 --kt 0.5

clean:
	rm -rf $(addsuffix *,$(ALL))
	rm -rf log *.log *.dat *.root *.run
	rm -rf RNDM* PYR* GiBUU* initHi* README*txt

