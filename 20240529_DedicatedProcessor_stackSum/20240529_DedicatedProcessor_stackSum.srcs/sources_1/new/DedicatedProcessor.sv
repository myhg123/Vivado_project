`timescale 1ns / 1ps
interface sig_interface;
    logic ISrcMuxSel;
    logic sumSrcMuxSel;
    logic ILoad;
    logic sumLoad;
    logic AdderSrcMuxSel;
    logic OutLoad;
    logic ILe10;
    logic [7:0] outPort;
    modport dp(
        input ISrcMuxSel,
        input sumSrcMuxSel,
        input ILoad,
        input sumLoad,
        input AdderSrcMuxSel,
        input OutLoad,
        output ILe10,
        output outPort
    );

    modport cu(
        output ISrcMuxSel,
        output sumSrcMuxSel,
        output ILoad,
        output sumLoad,
        output AdderSrcMuxSel,
        output OutLoad,
        input ILe10
    );

endinterface  //controlSignal

module DedicatedProcessor (
    input clk,
    input reset,
    output [7:0] outPort
);


    logic ILe10, ISrcMuxSel, sumSrcMuxSel, ILoad, sumLoad, AdderSrcMuxSel, OutLoad;

    DataPath U_DataPath (.*);

    ControlUnit U_ControlUnit (.*);

endmodule
