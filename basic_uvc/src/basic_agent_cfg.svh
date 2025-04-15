`ifndef BASIC_AGENT_CFG__SVH
`define BASIC_AGENT_CFG__SVH
 
class basic_agent_cfg extends uvm_object;

  virtual basic_if _vif;

  bit [1:0]     mode; 

  `uvm_object_utils_begin(basic_agent_cfg)
    `uvm_field_int(mode,UVM_ALL_ON) 
  `uvm_object_utils_end  

  function new(string name = "basic_agent_cfg");
    super.new(name);
  endfunction : new

endclass : basic_agent_cfg

`endif //BASIC_AGENT_CFG__SVH
