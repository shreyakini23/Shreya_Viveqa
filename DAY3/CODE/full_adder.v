module full_adder(a,b,cin,sum,carry);
input a,b,cin;
output sum,carry;

wire sum1,carry1,carry2;

half_adder ha1(a,b,sum1,carry1);
half_adder ha2(sum1,cin,sum,carry2);
or(carry,carry1,carry2);

endmodule
