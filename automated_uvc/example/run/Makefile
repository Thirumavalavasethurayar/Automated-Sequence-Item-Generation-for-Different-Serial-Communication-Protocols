clean:
		rm -fr work transcript *.log *.wlf *.svh

pyt:
		python excel.py eth.xlsx
		python excel.py can.xlsx

basic: 
		vlib work
		vlog +acc -sv -f flist -l comp.log
		vnc run -I vsim -local -c -wlf dump.wlf +UVM_TESTNAME=basic_test +UVM_VERBOSITY=UVM_FULL top -do run.do -l basic.log

tst: 
		vlib work
		vlog +acc -sv ../top.sv
		vnc run -I vsim -local -c -novopt -wlf dump.wlf top -do run.do -l basic.log
