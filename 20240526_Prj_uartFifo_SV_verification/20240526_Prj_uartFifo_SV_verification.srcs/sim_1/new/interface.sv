`ifndef  __INTERFACE_SV_
`define __INTERFACE_SV_

interface uartFifo_interface;
    logic clk;
    logic reset;

    logic  RX;
    logic  TX;

endinterface  //uartFifo_interface

`endif