//======================================================================================
// $File: 
// $Author: 
// $Revision: 
// $DateTime: 
// Description:
//
//======================================================================================

`ifndef BASIC_MONITOR__SVH
`define BASIC_MONITOR__SVH
class basic_monitor extends uvm_monitor;
  
  bit bit_q[$];
  bit byts[];
  logic [9:0] tmp_data;
  bit int_val;
  int tc,exp_tc;
  bit [3:0] dlc;
  bit [15:0] e_dlc;

  virtual basic_if if_0;
  basic_txn item;
  basic_agent_cfg _cfg;
  uvm_analysis_port #(basic_txn) basic_monitor_aport;
  
  `uvm_component_utils_begin(basic_monitor)
    `uvm_field_object(item,UVM_ALL_ON)
  `uvm_component_utils_end  

  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new  

  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task collect_data(basic_txn item);

  //Need to implement missing ESD_END using the max packet size.
endclass : basic_monitor 

function void basic_monitor::build_phase(uvm_phase phase);
  basic_monitor_aport  = new("basic_monitor_aport",this);
  item               = basic_txn::type_id::create("item");
  if(!uvm_config_db #(basic_agent_cfg)::get(this,"","basic_agent_cfg",_cfg)) begin
     `uvm_fatal(get_name(),"basic_agent_cfg is not retrived from DB");
  end
  if (!uvm_config_db #(virtual basic_if)::get(this,"","basic_vif",if_0)) begin
     `uvm_fatal(get_name(),"Incorrect Interface assignment");
  end

endfunction

task basic_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_name()," Main_phase starts",UVM_HIGH) 
  forever begin
    if (if_0.rst_n == 1'b0) begin
      @(negedge if_0.clk);
    end  
    else begin
      collect_data(item);
    end  
  end    
endtask

task basic_monitor::collect_data(basic_txn item);
    @(negedge if_0.clk);
    if(int_val == 0 && if_0.data == 1'b0 ) begin
      int_val = 1'b1;
    end  
    if(int_val == 1'b1) begin
      bit_q.push_back(if_0.data);
      tc = tc + 1;
      if(_cfg.mode == 1 && tc > 15 && tc < 20) begin
        dlc = {dlc[2:0],if_0.data};
      end else if(_cfg.mode == 2 && tc > 160 && tc < 177) begin
        e_dlc = {e_dlc[14:0],if_0.data};
      end
      if(_cfg.mode == 1 && tc == 20) begin
        exp_tc = dlc+19+25;
      end  else if(_cfg.mode == 2 && tc == 177) begin
        exp_tc = (e_dlc*8)+176+32;
        $display("exp_tc = %d",exp_tc);
        $display("e_dlc = %d",e_dlc);
      end  
      if(_cfg.mode == 1 && tc > 20 && exp_tc == tc) begin
        tmp_data = '1;
      end else  if(_cfg.mode == 2 && tc > 177 && exp_tc == tc) begin
        tmp_data = '1;
      end  
      if(tmp_data == '1) begin
        byts = new[bit_q.size()];
        foreach(bit_q[i]) begin
          byts[i] = bit_q[i];
        end  
        item.mode = _cfg.mode;
        void'(item.unpack(byts));
        basic_monitor_aport.write(item);
        `uvm_info(get_name(),$sformatf(" item in Monitor.."),UVM_HIGH)
        item.print();
        tmp_data = 10'hx;
        bit_q.delete();
        int_val=0;
        tc = 0;
        exp_tc = 0;
        dlc = 0;
        e_dlc = 0;
      end  
    end  
endtask


`endif //BASIC_MONITOR__SVH
