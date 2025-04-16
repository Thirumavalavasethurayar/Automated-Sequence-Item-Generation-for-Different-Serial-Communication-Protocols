`ifndef BASIC_TEST__SVH
`define BASIC_TEST__SVH
 
`include "run/can_txn.svh"
`include "run/eth_txn.svh"
class basic_test extends uvm_test;

  `uvm_component_utils(basic_test)
  
  basic_env _env;
  basic_agent_cfg _cfg;
  basic_sequence _seq;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  extern function void build_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
    
endclass : basic_test

function void basic_test::build_phase(uvm_phase phase);
  _env      = basic_env::type_id::create("_env",this);
  _cfg      = basic_agent_cfg::type_id::create("_cfg");
  _seq      = basic_sequence::type_id::create("_seq");
  _cfg.mode = 2; // 1- CAN 2 - ETHERNET 3 - AHB
  _seq.mode = _cfg.mode;
  if(_cfg.mode == 1)
    set_type_override_by_type(basic_txn::get_type(),can_txn::get_type());
  else if(_cfg.mode == 2)
    set_type_override_by_type(basic_txn::get_type(),eth_txn::get_type());
  uvm_config_db #(basic_agent_cfg)::set(null,"*","basic_agent_cfg",_cfg);
endfunction

task basic_test::main_phase (uvm_phase phase);
  phase.raise_objection(this);
  _seq.start(_env._agent.sequencer);
  #50ns;
  phase.drop_objection(this);
endtask

`endif //BASIC_TEST__SVH
