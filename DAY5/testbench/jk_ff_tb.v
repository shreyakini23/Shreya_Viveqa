`timescale 1ns/1ps

module jk_ff_tb;

reg clk;
reg rst;
reg j, k;
wire q, qb;

// Instantiate the JK Flip-Flop
jk_ff uut (
    .clk(clk),
    .rst(rst),
    .j(j),
    .k(k),
    .q(q),
    .qb(qb)
);

// Clock generation (10 ns period)
always #5 clk = ~clk;

initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    j = 0;
    k = 0;

    // Apply reset
    #10;
    rst = 0;

    // Test 00 (Hold)
    j = 0; k = 0;
    #10;

    // Test 10 (Set)
    j = 1; k = 0;
    #10;

    // Test 00 (Hold)
    j = 0; k = 0;
    #10;

    // Test 01 (Reset)
    j = 0; k = 1;
    #10;

    // Test 11 (Toggle)
    j = 1; k = 1;
    #10;

    // Toggle again
    j = 1; k = 1;
    #10;

    // Hold
    j = 0; k = 0;
    #10;

    // Apply reset again
    rst = 1;
    #10;
    rst = 0;

    #20;
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time=%0t | rst=%b j=%b k=%b | q=%b qb=%b",
             $time, rst, j, k, q, qb);
end

endmodule

