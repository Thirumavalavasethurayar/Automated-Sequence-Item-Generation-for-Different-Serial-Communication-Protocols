`ifndef BASIC_TXN__SVH
`define BASIC_TXN__SVH

class basic_txn extends uvm_sequence_item;
 
  rand bit          sof;  //start of frame
  rand bit[10:0]    b_id;   // Identifier
  rand bit[28:0]    e_id;   // Identifier
  rand struct packed{
    bit        rtr;  //remote transmission request
    bit        ide;  //Identifier extension
    bit        rsvd; //reserved_bit
    bit [3:0]  dlc;  //Data Length Code
  }basic_header;
  rand bit        data[];
  rand struct packed{
    bit [14:0] crc;
    bit        crc_delimiter;
    bit        ack;
    bit        ack_delimiter;
  }basic_footer;
  rand  bit        eof[];  //End of frame
  rand  bit [1:0]  inter_frame_gap;

  `uvm_object_utils_begin(basic_txn)
    `uvm_field_int(sof,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(b_id,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(e_id,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(basic_header,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_array_int(data,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(basic_footer,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_array_int(eof,UVM_ALL_ON|UVM_NOPACK)
  `uvm_object_utils_end
  
  constraint c_sof  { sof == 1'b0;} 
  constraint c_b_id {b_id == 11'h1BA;}
  constraint c_rtr  {basic_header.rtr == 1'b0;} // 0 - for DATA_FRAME 1 - REMOTE FRAME
  constraint c_ide  {basic_header.ide == 1'b0;} // 0 - for BASIC FRAME 1 - EXTENDED FRAME
  constraint c_rsvd {basic_header.rsvd == 1'b0;} 
  constraint c_data {data.size() == basic_header.dlc;} 
  constraint c_ack  {basic_footer.ack == 1'b1;} 
  constraint c_ackd {basic_footer.ack_delimiter == 1'b1;} 
  constraint c_eofs {eof.size() == 7;} 
  constraint c_eof  {foreach(eof[i]) eof[i] == 1'b1;} 
  constraint c_ifg  {inter_frame_gap == 2'd3;}

  function new(string name = "basic_txn");
    super.new(name);
  endfunction : new  

  function void do_pack(uvm_packer packer);
    super.do_pack(packer);

    packer.pack_field_int(sof,$bits(sof));
    packer.pack_field_int(b_id,$bits(b_id));
    packer.pack_field_int(basic_header,$bits(basic_header));
    foreach (data[i])
      packer.pack_field_int(data[i],1);
    packer.pack_field_int(basic_footer,$bits(basic_footer));
    foreach (eof[i])
      packer.pack_field_int(eof[i],1);
  endfunction : do_pack


  function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);

    sof        = packer.unpack_field_int($bits(sof));
    b_id       = packer.unpack_field_int($bits(b_id));
    basic_header = packer.unpack_field_int($bits(basic_header));
    
    data.delete();
    data = new[basic_header.dlc];

    foreach (data[i])
      data[i] = packer.unpack_field_int(1);
    basic_footer = packer.unpack_field_int($bits(basic_footer));
    eof.delete();
    eof = new[7];
    foreach (eof[i])
      eof[i] = packer.unpack_field_int(1);
  endfunction : do_unpack

endclass : basic_txn

`endif //BASIC_TXN__SVH
