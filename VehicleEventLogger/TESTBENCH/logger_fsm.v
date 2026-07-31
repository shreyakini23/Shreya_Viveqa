module logger_FSM_tb;

reg clk;
reg rst;
reg event_valid;

wire wr_en;

logger_fsm uut(
    .clk(clk),
    .rst(rst),
    .event_valid(event_valid),
    .wr_en(wr_en)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;
    event_valid = 0;

    #20;
    rst = 0;

    // First Event
    #20 event_valid = 1;
    #10 event_valid = 0;

    // Second Event
    #40 event_valid = 1;
    #10 event_valid = 0;

    #50;

    $finish;

end

endmodule
