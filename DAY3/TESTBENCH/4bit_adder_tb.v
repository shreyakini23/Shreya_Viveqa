module adder_4bit_tb();
reg [3:0]a,b;
wire [3:0]sum;
wire carry;

adder_4bit dut(a,b,sum,carry);

initial begin
a=4'd1;b=4'd2;
#10 a=4'd5;b=4'd5;
#10 a=4'd10;b=4'd5;
#10 a=4'd0;b=4'd15;
#10 a=4'd15;b=4'd15;
#10 a=4'd5;b=4'd9;
#10 a=4'd6;b=4'd9;
#10 a=4'd1;b=4'd2;
#10 a=4'd3;b=4'd7;
#10 $finish;
end

initial begin
$monitor("Sum of a=%d & b=%d is %d & the carry = %d",a,b,sum,carry);
end
endmodule
