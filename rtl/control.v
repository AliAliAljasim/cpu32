module control(
    input wire [6:0] opcode,

    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_read,
    output reg        mem_write,
    output reg [1:0]  wb_sel,     // 00=ALU result, 01=mem data, 10=PC+4, 11=imm (LUI)
    output reg        branch,
    output reg        jump,        // JAL or JALR: unconditional, writes PC+4 to rd
    output reg        jalr,        // JALR only: target = rs1+imm (vs PC+imm for JAL)
    output reg        alu_a_sel,   // 0=rs1, 1=PC (AUIPC)

    output reg [3:0]  alu_op
);

always @(*) begin

    // default values
    reg_write  = 0;
    alu_src    = 0;
    mem_read   = 0;
    mem_write  = 0;
    wb_sel     = 2'b00;
    branch     = 0;
    jump       = 0;
    jalr       = 0;
    alu_a_sel  = 0;
    alu_op     = 4'b0000;

    case (opcode)

        // R-type: ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
        7'b0110011: begin
            reg_write = 1;
            alu_src   = 0;
            wb_sel    = 2'b00;
            alu_op    = 4'b0000;
        end

        // I-type ALU: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
        7'b0010011: begin
            reg_write = 1;
            alu_src   = 1;
            wb_sel    = 2'b00;
            alu_op    = 4'b0000;
        end

        // LOAD: LB, LH, LW, LBU, LHU
        7'b0000011: begin
            reg_write = 1;
            alu_src   = 1;
            mem_read  = 1;
            wb_sel    = 2'b01;
            alu_op    = 4'b0000;
        end

        // STORE: SB, SH, SW
        7'b0100011: begin
            alu_src   = 1;
            mem_write = 1;
            alu_op    = 4'b0000;
        end

        // BRANCH: BEQ, BNE, BLT, BGE, BLTU, BGEU
        7'b1100011: begin
            branch = 1;
            alu_op = 4'b0000;
        end

        // LUI: rd = imm (upper 20 bits)
        7'b0110111: begin
            reg_write = 1;
            wb_sel    = 2'b11;
        end

        // AUIPC: rd = PC + imm
        7'b0010111: begin
            reg_write = 1;
            alu_src   = 1;
            alu_a_sel = 1;
            wb_sel    = 2'b00;
            alu_op    = 4'b0000;
        end

        // JAL: rd = PC+4, PC = PC + imm
        7'b1101111: begin
            reg_write = 1;
            jump      = 1;
            wb_sel    = 2'b10;
        end

        // JALR: rd = PC+4, PC = (rs1 + imm) & ~1
        7'b1100111: begin
            reg_write = 1;
            alu_src   = 1;
            jump      = 1;
            jalr      = 1;
            wb_sel    = 2'b10;
            alu_op    = 4'b0000;
        end

        // FENCE: treat as NOP
        7'b0001111: begin
        end

        // SYSTEM: ECALL, EBREAK - treat as NOP
        7'b1110011: begin
        end

        default: begin
        end

    endcase

end

endmodule
