module vehicle_blackbox_tb;

reg clk;
reg [7:0] sw;
reg [15:0] keypad;

wire [7:0] led;
wire uart_tx;

vehicle_blackbox_top DUT(
    .clk_24mhz(clk),
    .sw(sw),
    .keypad(keypad),
    .led(led),
    .uart_tx(uart_tx)
);

// Clock generation (50 MHz in simulation)
always #10 clk = ~clk;

initial
begin
    clk = 0;
    sw  = 0;
    keypad = 0;

    // Reset
    sw[6] = 1;
    #50;
    sw[6] = 0;
    #100;

    // Engine Start
    sw[4] = 1;
    #40;
    sw[4] = 0;
    #200;

    // Brake
    sw[0] = 1;
    #40;
    sw[0] = 0;
    #200;

    // Overspeed
    sw[1] = 1;
    #40;
    sw[1] = 0;
    #200;

    // Airbag
    sw[2] = 1;
    #40;
    sw[2] = 0;
    #500;

    // Press keypad key '0' to trigger the log dump
    // NOTE: debounce.v defaults to 480,000 cycles (~20ms) which is
    // far too slow for simulation as-is. Either:
    //  (a) temporarily override it here: change the DUT's debounce
    //      instance to use #(.DEBOUNCE_COUNT(5)), or
    //  (b) hold keypad high long enough to cover 480,000 cycles
    //      (very slow to simulate, not recommended)
    keypad[0] = 1;
    #200;
    keypad[0] = 0;

    // Give the FSM plenty of time to walk through the whole dump
    #2000000;

    $finish;
end

endmodule
