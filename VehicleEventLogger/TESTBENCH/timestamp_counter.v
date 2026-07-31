module timestamp_counter_tb();
reg clk;
reg rst;
wire [15:0]timestamp;
timestamp_counter uut(
   .rst(rst),
   .clk(clk),
   .timestamp(timestamp)
   );
always #5 clk = ~clk;

initial begin
 clk=0;
 rst=1;
 #20
 rst=0;
 
 #100;
 $finish;
 end
 endmodule
 
