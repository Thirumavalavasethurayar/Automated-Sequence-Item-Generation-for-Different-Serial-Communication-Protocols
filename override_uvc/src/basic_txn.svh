`ifndef BASIC_TXN__SVH
`define BASIC_TXN__SVH

class basic_txn extends uvm_sequence_item;
 
  bit [1:0] mode;
  rand bit [1:0] inter_frame_gap;

  `uvm_object_utils(basic_txn)
  
  function new(string name = "basic_txn");
    super.new(name);
  endfunction : new  

endclass : basic_txn

`endif //BASIC_TXN__SVH
