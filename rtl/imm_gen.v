module imm_gen(
    input  [31:0] instruction,
    output reg [31:0] imm
);

always @(*) begin
    case (instruction[6:0])

        // I-type: ALU (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI)
        7'b0010011:
            imm = {{20{instruction[31]}}, instruction[31:20]};

        // I-type: LOAD (LB, LH, LW, LBU, LHU)
        7'b0000011:
            imm = {{20{instruction[31]}}, instruction[31:20]};

        // I-type: JALR
        7'b1100111:
            imm = {{20{instruction[31]}}, instruction[31:20]};

        // S-type: STORE (SB, SH, SW)
        7'b0100011:
            imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

        // B-type: BRANCH (BEQ, BNE, BLT, BGE, BLTU, BGEU)
        7'b1100011:
            imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

        // U-type: LUI
        7'b0110111:
            imm = {instruction[31:12], 12'b0};

        // U-type: AUIPC
        7'b0010111:
            imm = {instruction[31:12], 12'b0};

        // J-type: JAL
        7'b1101111:
            imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

        // default
        default:
            imm = 32'b0;

    endcase
end

endmodule
