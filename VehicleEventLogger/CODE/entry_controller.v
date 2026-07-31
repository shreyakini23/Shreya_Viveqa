module entry_counter(
    input clk,
    input rst,
    input wr_en,
    output reg [4:0] log_count
);
always @(posedge clk)
begin
    if(rst)
        log_count <= 5'd0;
    else if(wr_en && log_count < 5'd16)
        log_count <= log_count + 1'b1;
end
endmodule
