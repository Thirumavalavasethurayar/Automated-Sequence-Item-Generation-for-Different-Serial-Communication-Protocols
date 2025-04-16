`ifndef CAN_TXN__SVH
`define CAN_TXN__SVH

class can_txn extends basic_txn; 

	rand	bit						sof;
	rand	bit	[10:0]					b_id;
	rand	bit	[28:0]					e_id;
	rand	bit						rtr;
	rand	bit						ide;
	rand	bit						rsvd;
	rand	bit	[3:0]					dlc;
	rand	bit						data[];
	rand	bit	[14:0]					crc;
	rand	bit						crc_delimiter;
	rand	bit						ack;
	rand	bit						ack_delimiter;
	rand	bit						eof[];
	rand	bit	[1:0]					inter_frame_gap;

	`uvm_object_utils_begin(can_txn)
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

	 constraint c_sof_0 {sof == 1'b0;}
	 constraint c_b_id_0 {b_id == 11'h1BA;}
	 constraint c_rtr_0 {rtr == 1'b0;}
	 constraint c_ide_0 {ide == 1'b0;}
	 constraint c_rsvd_0 {rsvd == 1'b0;}
	 constraint c_data_size {data.size()==dlc;}
	 constraint c_ack_0 {ack == 1'b1;}
	 constraint c_ack_delimiter_0 {ack_delimiter == 1'b1;}
	 constraint c_eof_size {eof.size()==7;}
	 constraint c_eof_i {foreach(eof[i]) eof[i]==1'b1;}
	 constraint c_inter_frame_gap_0 {inter_frame_gap == 2'h3;}

	function new (string name = "can_txn");
		super.new(name);
	endfunction:new

	function void do_pack (uvm_packer packer);
		super.do_pack(packer);
		packer.pack_field_int(sof,$bits(sof));
		packer.pack_field_int(b_id,$bits(b_id));
		packer.pack_field_int(rtr,$bits(rtr));
		packer.pack_field_int(ide,$bits(ide));
		packer.pack_field_int(rsvd,$bits(rsvd));
		packer.pack_field_int(dlc,$bits(dlc));
		foreach(data[i])
			packer.pack_field_int(data[i],1);
		packer.pack_field_int(crc,$bits(crc));
		packer.pack_field_int(crc_delimiter,$bits(crc_delimiter));
		packer.pack_field_int(ack,$bits(ack));
		packer.pack_field_int(ack_delimiter,$bits(ack_delimiter));
		foreach(eof[i])
			packer.pack_field_int(eof[i],1);
	endfunction : do_pack 

	function void do_unpack (uvm_packer packer);
		super.do_unpack(packer);
		sof = packer.unpack_field_int($bits(sof));
		b_id = packer.unpack_field_int($bits(b_id));
		rtr = packer.unpack_field_int($bits(rtr));
		ide = packer.unpack_field_int($bits(ide));
		rsvd = packer.unpack_field_int($bits(rsvd));
		dlc = packer.unpack_field_int($bits(dlc));
		data.delete();
		data = new[dlc];
		foreach(data[i])
			data[i] = packer.unpack_field_int(1);
		crc = packer.unpack_field_int($bits(crc));
		crc_delimiter = packer.unpack_field_int($bits(crc_delimiter));
		ack = packer.unpack_field_int($bits(ack));
		ack_delimiter = packer.unpack_field_int($bits(ack_delimiter));
		eof.delete();
		eof = new[7];
		foreach(eof[i])
			eof[i] = packer.unpack_field_int(1);
	endfunction : do_unpack 

endclass : can_txn 

`endif //CAN_TXN__SVH