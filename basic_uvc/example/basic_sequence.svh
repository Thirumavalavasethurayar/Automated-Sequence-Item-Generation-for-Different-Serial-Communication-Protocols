`ifndef BASIC_SEQUENCE__SVH
`define BASIC_SEQUENCE__SVH

class basic_sequence extends uvm_sequence #(basic_txn);
  `uvm_object_utils(basic_sequence)

  function new(string name = "basic_sequence");
    super.new(name);
  endfunction : new

  extern task body();
endclass

task basic_sequence::body();
  basic_txn item;
  for (int i = 0 ; i < 5; i++) begin
    item = basic_txn::type_id::create("item");
    wait_for_grant();
    void'(item.randomize());
    send_request(item);
  end
endtask : body

`endif //BASIC_SEQUENCE__SVH
