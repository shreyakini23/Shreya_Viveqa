module sev_seg_disp_tb;
    reg [3:0] B;
    wire a, b, c, d, e, f, g, h;
    sev_seg_disp uut (
        .B(B),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h)
    );

    initial begin
        $display("Time\tB\tabcdefgh");
        $monitor("%0t\t%b\t%b%b%b%b%b%b%b%b",
                 $time, B, a,b,c,d,e,f,g,h);

        B = 4'b0000; #10;
        B = 4'b0001; #10;
        B = 4'b0010; #10;
        B = 4'b0011; #10;
        B = 4'b0100; #10;
        B = 4'b0101; #10;
        B = 4'b0110; #10;
        B = 4'b0111; #10;
        B = 4'b1000; #10;
        B = 4'b1001; #10;
        B = 4'b1010; #10; 
        B = 4'b1111; #10; 

        $finish;
    end

endmodule
