`ifndef UART_TXN__SVH
`define UART_TXN__SVH

class uart_txn extends basic_txn; 

	rand	bit						start;
	rand	bit	[8:0]					data;
	rand	bit						parity;
	rand	bit	[1:0]					stop;

	`uvm_object_utils_begin(uart_txn)
		`uvm_field_int(start,UVM_ALL_ON|UVM_NOPACK)
		`uvm_field_int(data,UVM_ALL_ON|UVM_NOPACK)
		`uvm_field_int(parity,UVM_ALL_ON|UVM_NOPACK)
		`uvm_field_int(stop,UVM_ALL_ON|UVM_NOPACK)
	`uvm_object_utils_end

	 constraint c_start_0 {start == 1'b1;}
	 constraint c_stop_0 {stop == 1'b1;}

	function new (string name = "uart_txn");
		super.new(name);
	endfunction:new

	function void do_pack (uvm_packer packer);
		super.do_pack(packer);
		packer.pack_field_int(start,$bits(start));
		packer.pack_field_int(data,$bits(data));
		packer.pack_field_int(parity,$bits(parity));
		packer.pack_field_int(stop,$bits(stop));
	endfunction : do_pack 

	function void do_unpack (uvm_packer packer);
		super.do_unpack(packer);
		start = packer.unpack_field_int($bits(start));
		data = packer.unpack_field_int($bits(data));
		parity = packer.unpack_field_int($bits(parity));
		stop = packer.unpack_field_int($bits(stop));
	endfunction : do_unpack 

endclass : uart_txn 

`endif //UART_TXN__SVH