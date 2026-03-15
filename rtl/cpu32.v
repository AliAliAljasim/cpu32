module cpu32(
    input wire clk,
    input wire reset
);

wire [31:0] pc_value;
wire [31:0] instruction;
wire        zero;

// control signals
wire        reg_write;
wire        alu_src;
wire        mem_read;
wire        mem_write;
wire [1:0]  wb_sel;
wire        branch;
wire        jump;
wire        jalr;
wire        alu_a_sel;
wire [3:0]  alu_op;


// Instruction Memory
instr_mem instruction_memory(
    .addr(pc_value),
    .instruction(instruction)
);


// Control Unit
control control_unit(
    .opcode(instruction[6:0]),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .wb_sel(wb_sel),
    .branch(branch),
    .jump(jump),
    .jalr(jalr),
    .alu_a_sel(alu_a_sel),
    .alu_op(alu_op)
);


// Datapath
datapath cpu_datapath(
    .clk(clk),
    .reset(reset),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .wb_sel(wb_sel),
    .branch(branch),
    .jump(jump),
    .jalr(jalr),
    .alu_a_sel(alu_a_sel),
    .alu_op(alu_op),
    .instruction(instruction),
    .pc_value(pc_value),
    .zero(zero)
);

endmodule
