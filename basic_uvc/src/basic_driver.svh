//======================================================================================
// $File: 
// $Author: 
// $Revision: 
// $DateTime: 
// Description:
//
//======================================================================================

`ifndef BASIC_DRIVER__SVH
`define BASIC_DRIVER__SVH
class basic_driver extends uvm_driver #(basic_txn);
  
  virtual basic_if if_0;
  basic_txn item;
  basic_agent_cfg _cfg;
  bit byts[];

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new
    
  `uvm_component_utils_begin(basic_driver)
    `uvm_field_object(item,UVM_ALL_ON)
  `uvm_component_utils_end  

  extern virtual task uvc_to_dut(ref basic_txn item);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : basic_driver 

function void basic_driver::build_phase(uvm_phase phase);
   if(!uvm_config_db #(basic_agent_cfg)::get(this,"","basic_agent_cfg",_cfg)) begin
      `uvm_fatal(get_name(),"\"basic_agent_cfg\" is not retrived from DB");
   end
   if(!uvm_config_db #(virtual basic_if)::get(this,"","basic_vif",if_0)) begin
      `uvm_fatal(get_name(),"Incorrect Interface assignment");
   end
endfunction

task basic_driver::run_phase(uvm_phase phase);
  `uvm_info(get_name(),$sformatf(":run_phasening ....\n"),UVM_MEDIUM)
  forever begin
    if(if_0.rst_n == 1'b0) begin
      @(posedge if_0.clk);
      if_0.data       <= 1'd1;
    end
    else begin
      seq_item_port.get_next_item(item);
      uvc_to_dut(item);
      seq_item_port.item_done();
    end          
  end
endtask

task basic_driver::uvc_to_dut(ref basic_txn item);
  bit [3:0] data_nibble;

  void'(item.pack(byts));
  foreach(byts[i]) begin
    @(posedge if_0.clk);
    if_0.data     = byts[i];
  end
  repeat(item.inter_frame_gap) begin 
    @(posedge if_0.clk);
    if_0.data   = 1'b1;
  end
  `uvm_info(get_name(),$sformatf(" item is sent.."),UVM_HIGH)
  item.print();
endtask

`endif //BASIC_DRIVER__SVH
