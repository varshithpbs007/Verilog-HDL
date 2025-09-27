`timescale 1ns/1ps
module tb_alu8;
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] op;
    wire [7:0] Y;
    wire Z, C, V;

    alu8 dut(.A(A), .B(B), .op(op), .Y(Y), .Z(Z), .C(C), .V(V));

    initial begin
        $dumpfile("alu8.vcd");
        $dumpvars(0, tb_alu8);
        A = 8'h00;
        B = 8'h00;
        op = 3'b000;

        $display("time\tA\tB\top\tY\tZ C V");
        $monitor("%0t\t%h\t%h\t%b\t%h\t%b %b %b",$time,A,B,op,Y,Z,C,V);

        // Stimulus
        #5 A = 8'h00; B = 8'h00; op = 3'b000; #10; // add 0+0
        A = 8'h05; B = 8'h03; op = 3'b000; #10;    // add 5+3
        A = 8'hFF; B = 8'h01; op = 3'b000; #10;    // add with carry (255+1)
        A = 8'h05; B = 8'h03; op = 3'b001; #10;    // sub 5-3
        A = 8'h00; B = 8'h01; op = 3'b001; #10;    // sub borrow 0-1
        A = 8'hF0; B = 8'h0F; op = 3'b010; #10;    // AND
        A = 8'hF0; B = 8'h0F; op = 3'b011; #10;    // OR
        A = 8'hFF; B = 8'h0F; op = 3'b100; #10;    // XOR
        A = 8'h80; op = 3'b101; #10;               // SHL (msb out)
        A = 8'h01; op = 3'b110; #10;               // SHR (lsb out)
        A = 8'hAA; op = 3'b111; #10;               // PASS A
        #10;
        $finish;
    end
endmodule

