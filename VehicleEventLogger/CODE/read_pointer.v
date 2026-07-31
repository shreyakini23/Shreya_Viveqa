module read_pointer(
    input clk,
    input rst,
    input read_rst,        // ADD THIS
    input read_enable,
    output reg [3:0] read_address
);

always @(posedge clk)
begin
    if(rst || read_rst)    // CHANGED
        read_address <= 4'd0;
    else if(read_enable)
        read_address <= read_address + 1'b1;
end

endmodule
