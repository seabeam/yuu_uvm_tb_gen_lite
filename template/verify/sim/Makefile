ifeq ($(VCS_HOME),)
  $(error Please module load vcs first)
endif
ifeq ($(VERDI_HOME),)
  $(error Please module load verdi first)
endif

TB_DIR := {{ global_info['out_path'] }}
MODULE ?= {{ module }}
COMP_TOOL ?= vlogan
ELAB_TOOL ?= vcs
TIME_UNIT ?= 1ns
TIME_PREC ?= 1ps
SEED ?= 1
COVERAGE ?= 0
XPROP ?= 0
DEBUG_OPTS ?= -debug_acc+all
SIMV_OUT_DIR ?= simv_out/vcsobj
SIMV ?= $(MODULE)_$(TIME_UNIT)_$(TIME_PREC)$(DEBUG_OPTS)_simv

UVM_HOME ?= $(VCS_HOME)/etc/uvm-1.2
VERBOSITY ?= UVM_MEDIUM

VCS_COMP_OPTS ?= -full64 -sverilog -q +warn=noLCA_FEATURES_ENABLED -timescale=$(TIME_UNIT)/$(TIME_PREC) \
								 +libext+.v+.V+.vlib+.sv+.svh -ntb_opts uvm-1.2 $(DEBUG_OPTS) -kdb -lca
VCS_ELAB_OPTS ?= -full64 -q +warn=noLCA_FEATURES_ENABLED -reportstats -j8 -partcomp -fastpartcomp=j8 +notimingcheck +nospecify -nc \
								 -timescale=$(TIME_UNIT)/$(TIME_PREC) +vpi -CFLAGS "-I$(UVM_HOME)/dpi/ -DVCS" \
								 -lca -kdb +rad $(DEBUG_OPTS) -top {{ module }}_top -o $(SIMV_OUT_DIR)/$(SIMV) -l elab.log
VCS_RUN_OPTS ?= -lca +warn=noLCA_FEATURES_ENABLED -ucli -do sim.tcl +UVM_VERBOSITY=$(VERBOSITY) +UVM_TESTNAME=$(TEST) -l sim.log
C_COMP_OPTS ?= -Wall -Werror-implicit-function-declaration -m64 -fPIC -g -shared -DVCS
VIP_COM_COMP_OPTS ?= {% if vip_info != {} %}{% endif %}
TB_COMP_VIP_OPTS ?= {% if vip_info != {} %}{% endif %}

TB_COMP_OPTS ?= $(TB_COMP_VIP_OPTS) \
								+incdir+$(TB_DIR)/verify/case+$(TB_DIR)/verify/cov+$(TB_DIR)/verify/env+$(TB_DIR)/verify/include \
								+incdir+$(TB_DIR)/verify/include+$(TB_DIR)/verify/reg+$(TB_DIR)/verify/seq+$(TB_DIR)/verify/top \
								$(TB_DIR)/verify/env/{{ module }}_pkg.sv $(TB_DIR)/verify/seq/{{ module }}_sequence_pkg.sv \
								$(TB_DIR)/verify/case/{{ module }}_test_pkg.sv $(TB_DIR)/verify/top/{{ module }}_top.sv

ifeq ($(COVERAGE), 1)
	COV_TYPE ?= line+tgl+fsm+cond+branch+assert
	COV_HIER_CFG ?= cov_hier.cfg
	VCS_COMP_OPTS += -cm $(COV_TYPE) -cm_tgl portsonly -cm_hier $(COV_HIER_CFG)
	VCS_RUN_OPTS += -cm $(COV_TYPE) -cm_name $(TEST) -cm_dir $(SIMV_OUT_DIR)/cov_$(SIMV)
	SIMV := $(SIMV).cov
endif

ifeq ($(XPROP), 1)
	XPROP_CFG ?= xprop.cfg
	VCS_COMP_OPTS += -xpop=xprop.cfg
endif

ifeq ($(SEED), random)
	VCS_RUN_OPTS += +ntb_random_seed_automatic
else
	VCS_RUN_OPTS += +ntb_random_seed=$(SEED)
endif
ifneq ($(GUI),)
	VCS_RUN_OPTS += -gui
endif


clean:
	- ls | grep -v Makefile | grep -v sim.tcl | xargs rm -rf
	- rm .shadow -rf

preproc:
	mkdir -p .shadow
	make .shadow/preproc

.shadow/preproc:
	mkdir -p $(SIMV_OUT_DIR)
	@touch $@

comp_rtl:
	make .shadow/comp_rtl

.shadow/comp_rtl:
	@echo "Compile RTL"
	touch $@

.shadow/comp_uvm:
	@echo "Compile UVM"
	$(COMP_TOOL) $(VCS_COMP_OPTS) +incdir+$(UVM_HOME) $(UVM_HOME)/uvm_pkg.sv +define+UVM_NO_DEPRECATED +define+UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR
	touch $@

.shadow/comp_vip:
	@echo "Compile VIP"
{% if vip_info != {} %}
	$(COMP_TOOL) $(VCS_COMP_OPTS) $(VIP_COM_COMP_OPTS)
	touch $@
{% endif %}

comp_tb:
	@echo "Compile TB"
	make .shadow/comp_tb

.shadow/comp_tb: .shadow/comp_uvm .shadow/comp_vip
	$(COMP_TOOL) $(VCS_COMP_OPTS) $(TB_COMP_OPTS)

elab: preproc comp_rtl comp_tb
	$(ELAB_TOOL) $(VCS_ELAB_OPTS) $(UVM_HOME)/dpi/uvm_dpi.cc

run:
	@mkdir -p simu/$(TEST)_$(SEED)
	@rm simu/$(TEST)_$(SEED)/* -rf
	@cd simu/$(TEST)_$(SEED); \
	ln -s sim.tcl; \
	ln -s ../../$(SIMV_OUT_DIR)/$(SIMV); \
	ln -s ../../$(SIMV_OUT_DIR)/$(SIMV).daidir; \
	ln -s $(TB_DIR)/verify/case/$(TEST)/* ./; \
	if [ -e preproc.sh ]; then preproc.sh; fi; \
	$(SIMV) $(VCS_RUN_OPTS); \
	if [ -e postproc.sh ]; then postproc.sh; fi
