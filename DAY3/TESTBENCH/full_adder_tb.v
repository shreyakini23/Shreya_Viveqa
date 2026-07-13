module full_adder_tb();
reg a,b,cin;
wire sum,carry;

full_adder dut(a,b,cin,sum,carry);

integer i;

initial begin
for(i=0;i<8;i=i+1)begin
{a,b,cin}=i;
#10;
end
$finish;
end
endmodule
