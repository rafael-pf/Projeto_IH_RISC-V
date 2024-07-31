`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,
        input logic [8:0]    PC,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0010:        // ADD
                    ALUResult = $signed(SrcA) + $signed(SrcB);
            4'b1000:        // Equal
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b0001:       // OR
                    ALUResult = SrcA | SrcB;
            4'b0011:       // SUB
                    ALUResult = $signed(SrcA) - $signed(SrcB);
            4'b0100:       // XOR
                    ALUResult = SrcA ^ SrcB;
            4'b0101:       // SLL/SLLI
                    ALUResult = SrcA << SrcB;
            4'b0110:       // SRL/SRLI
                    ALUResult = SrcA >> SrcB;
            4'b0111:       // SRA/SRAI
                    ALUResult = $signed(SrcA) >>> SrcB[4:0];
            4'b1001:       // SLT/SLTI
                    ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 1 : 0;
            4'b1010:       // BGE
                    ALUResult = ($signed(SrcA) >= $signed(SrcB)) ? 1 : 0;
            4'b1011:       // BLT
                    ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 1 : 0;
            4'b1100:       // BNE
                    ALUResult = (SrcA != SrcB) ? 1 : 0;
            4'b1101:      // JALR
                    ALUResult = SrcA + SrcB;
            default:
                    ALUResult = 0;
            endcase
        end
endmodule

