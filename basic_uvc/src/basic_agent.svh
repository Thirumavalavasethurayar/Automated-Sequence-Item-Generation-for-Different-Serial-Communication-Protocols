`ifndef BASIC_AGENT__SVH
`define BASIC_AGENT__SVH
 
class basic_agent extends uvm_agent;
  `uvm_component_utils(basic_agent)
 
  basic_agent_cfg           _cfg;

  basic_driver              driver;
  basic_monitor             monitor;
  uvm_sequencer#(basic_txn) sequencer;

  uvm_analysis_port #(basic_txn) basic_ap;

  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    basic_ap          = new ("basic_ap",this);
    sequencer       = uvm_sequencer#(basic_txn)::type_id::create("sequencer",this);
    driver          = basic_driver::type_id::create("driver",this);
    monitor         = basic_monitor::type_id::create("monitor",this);
    if(!uvm_config_db #(basic_agent_cfg)::get(this,"","basic_agent_cfg",_cfg)) begin
       `uvm_fatal(get_name(),"frame_agent_cfg is not retrived from DB");
    end

  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
    monitor.basic_monitor_aport.connect(this.basic_ap);
  endfunction : connect_phase

  
endclass : basic_agent

`endif //BASIC_AGENT__SVH
