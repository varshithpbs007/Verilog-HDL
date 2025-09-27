`timescale 1ns/1ps
module tb_alu8_random;
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] op;
    wire [7:0] Y;
    wire Z, C, V;

    alu8 dut(.A(A), .B(B), .op(op), .Y(Y), .Z(Z), .C(C), .V(V));

    integer i;
    reg [8:0] golden;
    reg goldenC, goldenV;
    reg [7:0] goldenY;
    reg goldenZ;

    initial begin
        $dumpfile("alu8_random.vcd");
        $dumpvars(0, tb_alu8_random);

        for (i=0; i<200; i=i+1) begin
            A = $random;
            B = $random;
            op = $random % 8;
            #1; // let outputs settle

            case (op)
                3'b000: begin // ADD
                    golden = {1'b0, A} + {1'b0, B};
                    goldenY = golden[7:0];
                    goldenC = golden[8];
                    goldenV = (A[7] & B[7] & ~goldenY[7]) | (~A[7] & ~B[7] & goldenY[7]);
                end
                3'b001: begin // SUB
                    golden = {1'b0, A} - {1'b0, B};
                    goldenY = golden[7:0];
                    goldenC = (A < B);
                    goldenV = (A[7] & ~B[7] & ~goldenY[7]) | (~A[7] & B[7] & goldenY[7]);
                end
                3'b010: begin goldenY = A & B; goldenC = 0; goldenV = 0; end
                3'b011: begin goldenY = A | B; goldenC = 0; goldenV = 0; end
                3'b100: begin goldenY = A ^ B; goldenC = 0; goldenV = 0; end
                3'b101: begin goldenY = A << 1; goldenC = A[7]; goldenV = 0; end
                3'b110: begin goldenY = A >> 1; goldenC = A[0]; goldenV = 0; end
                3'b111: begin goldenY = A; goldenC = 0; goldenV = 0; end
            endcase
            goldenZ = (goldenY == 8'b0);

            if (Y !== goldenY || C !== goldenC || V !== goldenV || Z !== goldenZ) begin
                $display("Mismatch at iter %0d: op=%b A=%02h B=%02h | got Y=%02h Z=%b C=%b V=%b | exp Y=%02h Z=%b C=%b V=%b",
                          i,op,A,B,Y,Z,C,V,goldenY,goldenZ, goldenC, goldenV);
            end
            #1;
        end
        $display("Random test complete");
        #10;
        $finish;
    end
endmodule

