`ifndef TOP__SV
`define TOP__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

import basic_pkg::*;
`include "basic_if.sv"
`include "basic_sequence.svh"
`include "basic_env.svh"
`include "basic_test.svh"

module top;
  timeunit 1ns;
  timeprecision 1ps;

  logic clk;
  logic rst_n;

  basic_if _vif(clk,rst_n);
  initial begin
   uvm_config_db #(virtual basic_if)::set(null,"*","basic_vif",_vif);
   run_test();
  end
  initial begin
    //Set the Time Format
    //time unit, precision number, suffix string, min field width
    //$timeformat(-12,2," ps",15);
  end

  // Generate clock signal 25 MHz
  // Generate clock signal 16 MHz
  initial
  begin
    clk=0;
    //forever #20 clk = ~clk;
    forever #31.25 clk = ~clk;
  end


  initial begin
    rst_n       = 0;
    #80 rst_n   = 1'b1;
  end
  // To run the example change the output to inout for loop back purpose
  //assign mii_to_phy_if.rxd      = mii_to_phy_if.txd;
  //assign mii_to_phy_if.rxd_vld  = mii_to_phy_if.txd_vld;
  //assign mii_to_phy_if.rxd_k    = mii_to_phy_if.txd_k;
endmodule : top
`endif //TOP__SV
