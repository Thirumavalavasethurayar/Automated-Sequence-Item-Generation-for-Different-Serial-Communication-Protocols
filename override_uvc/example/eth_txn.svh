`ifndef ETH_TXN__SVH
`define ETH_TXN__SVH

class eth_txn extends basic_txn;
 
  bit              mode;
  rand  bit [1:0]  inter_frame_gap;
  rand bit [55:0] preamble;
  rand bit [7:0] sfd;
  rand bit [47:0] da;
  rand bit [47:0] sa;
  rand bit [15:0] length;
  rand bit [7:0] eth_data[];
  rand bit [31:0] eth_crc;
  //rand  bit [1:0]  inter_frame_gap;
    

  `uvm_object_utils_begin(eth_txn)
    `uvm_field_int(preamble,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(sfd,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(da,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(sa,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(length,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_array_int(eth_data,UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(eth_crc,UVM_ALL_ON|UVM_NOPACK)
  `uvm_object_utils_end
  
  constraint c_ifg  {inter_frame_gap == 2'd3;}
  constraint c_length {length inside {[46:1500]};}
  constraint c_eth_data {eth_data.size() == length;}
  constraint preamble_msb {preamble[55] == 0;}

  function new(string name = "eth_txn");
    super.new(name);
  endfunction : new  

  function void do_pack(uvm_packer packer);
    super.do_pack(packer);

    packer.pack_field_int(preamble,$bits(preamble));
    packer.pack_field_int(sfd,$bits(sfd));
    packer.pack_field_int(da,$bits(da));
    packer.pack_field_int(sa,$bits(sa));
    packer.pack_field_int(length,$bits(length));
    foreach (eth_data[i])
      packer.pack_field_int(eth_data[i],$bits(eth_data[i]));
    packer.pack_field_int(eth_crc,$bits(eth_crc));
  endfunction : do_pack


  function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);

    preamble   = packer.unpack_field_int($bits(preamble));
    sfd        = packer.unpack_field_int($bits(sfd));
    da         = packer.unpack_field_int($bits(da));
    sa         = packer.unpack_field_int($bits(sa));
    length     = packer.unpack_field_int($bits(length));
    
    eth_data.delete();
    eth_data = new[length];

    foreach (eth_data[i]) begin
      eth_data[i] = packer.unpack_field_int($bits(eth_data[i]));
      //eth_data[i] = packer.unpack_field_int($bits(eth_data[i]));
    end  
    eth_crc = packer.unpack_field_int($bits(eth_crc));
  endfunction : do_unpack

endclass : eth_txn

`endif //ETH_TXN__SVH
