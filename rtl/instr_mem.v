module instr_mem(
    input wire [31:0] addr,
    output wire [31:0] instruction
);

reg [31:0] memory [255:0];

initial begin
    // ---------------------------------------------------------------
    // Test program: exercises new RV32I instructions
    // Expected register values after completion:
    //   x1  = 10        (ADDI)
    //   x2  = 20        (ADDI)
    //   x3  = 0x1000    (LUI x3, 1  -> upper imm = 1 << 12)
    //   x4  = 12        (AUIPC x4, 0 -> PC=12 + 0 = 12)
    //   x5  = 20        (JAL at PC=16, writes PC+4=20 to x5)
    //   x6  = 7         (jumped over two ADDI x6,x0,99 instructions)
    //   x7  = 42        (BLT taken: x1(10) < x2(20) -> skip ADDI x7,x0,99)
    // ---------------------------------------------------------------

    // [0]  addr=0:  ADDI x1, x0, 10       x1 = 10
    memory[0]  = 32'h00A00093;

    // [1]  addr=4:  ADDI x2, x0, 20       x2 = 20
    memory[1]  = 32'h01400113;

    // [2]  addr=8:  LUI x3, 1             x3 = 0x00001000
    memory[2]  = 32'h000011B7;

    // [3]  addr=12: AUIPC x4, 0           x4 = PC + 0 = 12
    memory[3]  = 32'h00000217;

    // [4]  addr=16: JAL x5, 12            x5 = 20, jump to addr 28
    //   J-imm=12: inst = 0_0000000110_0_00000000_00101_1101111 = 0x00C002EF
    memory[4]  = 32'h00C002EF;

    // [5]  addr=20: (skipped by JAL) ADDI x6, x0, 99
    memory[5]  = 32'h06300313;

    // [6]  addr=24: (skipped by JAL) ADDI x6, x0, 99
    memory[6]  = 32'h06300313;

    // [7]  addr=28: ADDI x6, x0, 7        x6 = 7  (JAL lands here)
    memory[7]  = 32'h00700313;

    // [8]  addr=32: BLT x1, x2, 8         x1(10) < x2(20) => take, jump to addr 40
    //   B-imm=8: inst = 0_000000_00010_00001_100_0100_0_1100011 = 0x0020C463
    memory[8]  = 32'h0020C463;

    // [9]  addr=36: (skipped by BLT) ADDI x7, x0, 99
    memory[9]  = 32'h06300393;

    // [10] addr=40: ADDI x7, x0, 42       x7 = 42  (BLT lands here)
    memory[10] = 32'h02A00393;

    // [11] addr=44: NOP
    memory[11] = 32'h00000013;
    memory[12] = 32'h00000013;

end

assign instruction = memory[addr[9:2]];

endmodule
