module write_pointer(
 
input clk,
input rst,
input write_enable,
 
output reg [3:0] write_address
 
);
 
always @(posedge clk)
 
begin
 
    if(rst)
 
        write_address <= 4'd0;
 
    else if(write_enable)
 
        write_address <= write_address + 1'b1;
 
end
endmodule
