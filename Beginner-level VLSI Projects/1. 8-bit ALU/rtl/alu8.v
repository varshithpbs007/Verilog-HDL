// alu8.v
// 8-bit ALU with flags
// ops:
// 000: ADD
// 001: SUB (A - B)
// 010: AND
// 011: OR
// 100: XOR
// 101: SHL (A << 1)
// 110: SHR (A >> 1)
// 111: PASS A

`timescale 1ns/1ps
module alu8 (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [2:0] op,
    output reg  [7:0] Y,
    output reg        Z, // zero flag
    output reg        C, // carry / borrow (for add/sub or shifted-out bit)
    output reg        V  // overflow (signed)
);

    reg [8:0] tmp; // 9 bits to capture carry/borrow

    always @(*) begin
        tmp = 9'b0;
        Y = 8'b0;
        C = 1'b0;
        V = 1'b0;
        case (op)
            3'b000: begin // ADD
                tmp = {1'b0, A} + {1'b0, B};
                Y = tmp[7:0];
                C = tmp[8];
                // signed overflow: when A and B have same sign but result has different sign
                V = (A[7] & B[7] & ~Y[7]) | (~A[7] & ~B[7] & Y[7]);
            end
            3'b001: begin // SUB (A - B)
                tmp = {1'b0, A} - {1'b0, B};
                Y = tmp[7:0];
                // borrow if A < B
                C = (A < B);
                // overflow for subtraction: when A and B have different sign and result sign differs from A
                V = (A[7] & ~B[7] & ~Y[7]) | (~A[7] & B[7] & Y[7]);
            end
            3'b010: Y = A & B;
            3'b011: Y = A | B;
            3'b100: Y = A ^ B;
            3'b101: begin // SHL logical left by 1
                Y = A << 1;
                C = A[7]; // MSB shifted out
            end
            3'b110: begin // SHR logical right by 1
                Y = A >> 1;
                C = A[0]; // LSB shifted out
            end
            3'b111: Y = A; // PASS A
            default: Y = 8'b0;
        endcase
        Z = (Y == 8'b0);
    end

endmodule
