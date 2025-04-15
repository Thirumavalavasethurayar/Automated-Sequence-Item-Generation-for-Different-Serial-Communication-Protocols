`ifndef BASIC_ENV__SVH
`define BASIC_ENV__SVH
class basic_env extends uvm_env;

  `uvm_component_utils(basic_env)

  basic_agent _agent;
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  extern function void build_phase(uvm_phase phase);
    
endclass : basic_env 

function void basic_env::build_phase(uvm_phase phase);
  _agent = basic_agent::type_id::create("_agent",this);
endfunction
  
`endif //BASIC_ENV__SVH
