`ifndef  __TRANSACTION_SV_
`define __TRANSACTION_SV_

class transaction;
    randc logic [7:0] rx_data;
    logic [7:0] tx_data;

    constraint c_rxdata{rx_data < 8'd99;}

    task display(string name);
        $display("[%s] rx_data = %d, tx_data = %d ", name, rx_data, tx_data);
    endtask

endclass  //transaction

`endif