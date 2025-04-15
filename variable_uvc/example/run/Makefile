clean:
		rm -fr work transcript *.log *.wlf

basic: clean
		vlib work
		vlog +acc -sv -f flist -l comp.log
		vsim -wlf dump.wlf +UVM_TESTNAME=basic_test +UVM_VERBOSITY=UVM_FULL top -do run.do -l basic.log

tst: clean
		vlib work
		vlog +acc -sv ../top.sv
		vnc run -I vsim -local -c -novopt -wlf dump.wlf top -do run.do -l basic.log
