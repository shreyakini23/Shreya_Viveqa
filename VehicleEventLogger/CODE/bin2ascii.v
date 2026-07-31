module bin2ascii(
input [15:0]binary,
output reg[7:0]ascii3,
output reg[7:0]ascii2,
output reg[7:0] ascii1,
output reg[7:0]ascii0
    );
    integer temp;
    always@(*)begin
    temp = binary % 10000;    // NEW: clamp to 0-9999 before converting
    ascii3= (temp/1000)+8'd48;
    temp=temp%1000;
    ascii2= (temp/100)+8'd48;
    temp=temp%100;
    ascii1= (temp/10)+8'd48;
    ascii0= temp%10+8'd48;
    end
    endmodule
 
