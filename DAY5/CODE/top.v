module Top(clk,rst,A,B,M,Q,Qb);
input clk,rst;
input A,B;
input [1:0]M;
output Q,Qb;

wire Qd, Qbd, Qt,Qtb, Qjk, Qjkb;
wire T_in,JK_in;

dff dff1(clk,rst,A,Qd,Qbd);

assign T_in=A^Qt;

dff tff1(clk,rst,T_in,Qt,Qtb);

assign JK_in=(A & Qjkb) | (~B & Qjk);

dff jkff1(clk,rst,JK_in,Qjk,Qjkb);


always @ (*)begin
case(M)
2'b00: begin
		Q=Qd;
		Qb=Qbd
	   end 
2'b01: begin
		Q=Qt;
		Qb=Qtb
	   end 
2'b10: begin
		Q=Qjk;
		Qb=Qjkb
	   end 
endcase
end

endmodule
