module debounce(
    input clk,
    input rst,
    input btn_in,
    output reg pulse_out    // one-cycle pulse per clean press
);

// ~20ms debounce at 24MHz = 480,000 cycles.
// Simulation-friendly parameter override available.
parameter DEBOUNCE_COUNT = 480000;

reg [18:0] counter;
reg btn_sync0, btn_sync1;   // 2-flop synchronizer
reg btn_stable;
reg btn_stable_prev;

always @(posedge clk)
begin
    if(rst)
    begin
        btn_sync0     <= 1'b0;
        btn_sync1     <= 1'b0;
        counter       <= 0;
        btn_stable    <= 1'b0;
        btn_stable_prev <= 1'b0;
        pulse_out     <= 1'b0;
    end
    else
    begin
        // synchronize async button input
        btn_sync0 <= btn_in;
        btn_sync1 <= btn_sync0;

        // debounce counter
        if(btn_sync1 == btn_stable)
        begin
            counter <= 0;
        end
        else
        begin
            counter <= counter + 1'b1;
            if(counter >= DEBOUNCE_COUNT)
            begin
                btn_stable <= btn_sync1;
                counter <= 0;
            end
        end

        btn_stable_prev <= btn_stable;

        // one-shot pulse on rising edge of stable button
        pulse_out <= (btn_stable && !btn_stable_prev) ? 1'b1 : 1'b0;
    end
end

endmodule
