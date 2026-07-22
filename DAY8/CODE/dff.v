module Dff(clk,rst,ip,op);
input clk,rst;
input ip;
output op;

wire d1;
wire q0,qb0,q1,qb1;

dfff dff0(clk,rst,~ip,q0,qb0);

assign d1=ip&q0;

dfff dff1(clk,rst,d1,q1,qb1);

assign op=ip&q1;

endmodule
