module timestamp_counter(clk,rst,timestamp);
output reg [15:0]timestamp;
input rst;
input clk;

always@(posedge clk)begin
 if(rst)
 timestamp <=16'd0;
 else
 timestamp<= timestamp+1;
 end
endmodule
