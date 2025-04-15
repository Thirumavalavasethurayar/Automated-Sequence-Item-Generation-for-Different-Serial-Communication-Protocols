`ifndef CAN_TXN__SVH
`define CAN_TXN__SVH

class can_txn extends basic_txn;
 
  bit               mode;
  rand bit          sof;  //start of frame
  rand bit[10:0]    b_id;   // Identifier
  rand bit[28:0]    e_id;   // Identifier
  rand bit        rtr;  //remote transmission request
  rand bit        ide;  //Identifier extension
  rand bit        rsvd; //reserved_bit
  rand bit [3:0]  dlc;  //Data Length Code
  rand bit        data[];
  rand bit [14:0] crc;
  rand bit        crc_delimiter;
  rand bit        ack;
  rand bit        ack_delimiter;
  rand bit        eof[];  //End of frame
  //rand  bit [1:0]  inter_frame_gap;

  `uvm_object_utils_begin(can_txn)
    `uvm_field_int(mode,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(sof,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(b_id,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(e_id,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(rtr,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(ide,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(rsvd,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(dlc,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_array_int(data,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(crc,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(crc_delimiter,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(ack,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(ack_delimiter,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_array_int(eof,UVM_ALL_ON|UVM_NOPACK)
  `uvm_object_utils_end
  
  constraint c_sof  { sof == 1'b0;} 
  constraint c_b_id {b_id == 11'h1BA;}
  constraint c_rtr  {rtr == 1'b0;} // 0 - for DATA_FRAME 1 - REMOTE FRAME
  constraint c_ide  {ide == 1'b0;} // 0 - for BASIC FRAME 1 - EXTENDED FRAME
  constraint c_rsvd {rsvd == 1'b0;} 
  constraint c_data {data.size() == dlc;} 
  constraint c_ack  {ack == 1'b1;} 
  constraint c_ackd {ack_delimiter == 1'b1;} 
  constraint c_eofs {eof.size() == 7;} 
  constraint c_eof  {foreach(eof[i]) eof[i] == 1'b1;} 
  constraint c_ifg  {inter_frame_gap == 2'd3;}

  function new(string name = "can_txn");
    super.new(name);
  endfunction : new  

  function void do_pack(uvm_packer packer);
    super.do_pack(packer);

      packer.pack_field_int(sof,$bits(sof));
      packer.pack_field_int(b_id,$bits(b_id));
      packer.pack_field_int(rtr,$bits(rtr));
      packer.pack_field_int(ide,$bits(ide));
      packer.pack_field_int(rsvd,$bits(rsvd));
      packer.pack_field_int(dlc,$bits(dlc));
      foreach (data[i])
        packer.pack_field_int(data[i],1);
      packer.pack_field_int(crc,$bits(crc));
      packer.pack_field_int(crc_delimiter,$bits(crc_delimiter));
      packer.pack_field_int(ack,$bits(ack));
      packer.pack_field_int(ack_delimiter,$bits(ack_delimiter));
      foreach (eof[i])
        packer.pack_field_int(eof[i],1);
  endfunction : do_pack


  function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);

    sof        = packer.unpack_field_int($bits(sof));
    b_id       = packer.unpack_field_int($bits(b_id));
    rtr = packer.unpack_field_int($bits(rtr));
    ide = packer.unpack_field_int($bits(ide));
    rsvd = packer.unpack_field_int($bits(rsvd));
    dlc = packer.unpack_field_int($bits(dlc));
    
    data.delete();
    data = new[dlc];

    foreach (data[i])
      data[i] = packer.unpack_field_int(1);
    crc = packer.unpack_field_int($bits(crc));
    crc_delimiter = packer.unpack_field_int($bits(crc_delimiter));
    ack = packer.unpack_field_int($bits(ack));
    ack_delimiter = packer.unpack_field_int($bits(ack_delimiter));
    eof.delete();
    eof = new[7];
    foreach (eof[i])
      eof[i] = packer.unpack_field_int(1);
  endfunction : do_unpack

endclass : can_txn

`endif //CAN_TXN__SVH
