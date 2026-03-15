module datapath(
    input wire        clk,
    input wire        reset,

    // control signals
    input wire        reg_write,
    input wire        alu_src,
    input wire        mem_read,
    input wire        mem_write,
    input wire [1:0]  wb_sel,     // 00=ALU, 01=mem, 10=PC+4, 11=imm (LUI)
    input wire        branch,
    input wire        jump,        // JAL or JALR
    input wire        jalr,        // JALR: target = rs1+imm
    input wire        alu_a_sel,   // 0=rs1, 1=PC (AUIPC)
    input wire [3:0]  alu_op,

    // instruction input
    input wire [31:0] instruction,

    // outputs
    output wire [31:0] pc_value,
    output wire        zero
);

// datapath wires
wire [31:0] reg_data1;
wire [31:0] reg_data2;
wire [31:0] imm;
wire [31:0] alu_input_a;
wire [31:0] alu_input_b;
wire [31:0] alu_result;
wire [31:0] mem_data;
wire [31:0] writeback_data;
wire [31:0] pc_plus4;

// jump / branch control
wire        take_branch;
wire        pc_sel;
wire [31:0] branch_target;   // PC + imm  (branches and JAL)
wire [31:0] jalr_target;     // (rs1 + imm) & ~1
wire [31:0] jump_target;     // selected target fed to PC

// condition flags
wire lt;
wire ltu;

// instruction decode
wire [2:0] funct3;
wire [6:0] funct7;

assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];

assign pc_plus4      = pc_value + 4;
assign branch_target = pc_value + imm;
assign jalr_target   = (reg_data1 + imm) & ~32'h1;
assign jump_target   = jalr ? jalr_target : branch_target;
assign pc_sel        = jump | take_branch;


// Program Counter
pc program_counter(
    .clk(clk),
    .reset(reset),
    .pc_sel(pc_sel),
    .jump_target(jump_target),
    .pc(pc_value)
);


// Register File
regfile registers(
    .clk(clk),
    .we(reg_write),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(instruction[11:7]),
    .write_data(writeback_data),
    .read_data1(reg_data1),
    .read_data2(reg_data2)
);


// Immediate Generator
imm_gen immediate_generator(
    .instruction(instruction),
    .imm(imm)
);


// ALU input A mux: rs1 (normal) or PC (AUIPC)
mux2 alu_a_mux(
    .a(reg_data1),
    .b(pc_value),
    .sel(alu_a_sel),
    .y(alu_input_a)
);


// ALU input B mux: rs2 or immediate
mux2 alu_b_mux(
    .a(reg_data2),
    .b(imm),
    .sel(alu_src),
    .y(alu_input_b)
);


// ALU
alu arithmetic_unit(
    .a(alu_input_a),
    .b(alu_input_b),
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .result(alu_result),
    .zero(zero),
    .lt(lt),
    .ltu(ltu)
);


// Data Memory
data_mem memory(
    .clk(clk),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .funct3(funct3),
    .addr(alu_result),
    .write_data(reg_data2),
    .read_data(mem_data)
);


// Branch Unit
branch_unit branch_logic(
    .branch(branch),
    .funct3(funct3),
    .zero(zero),
    .lt(lt),
    .ltu(ltu),
    .take_branch(take_branch)
);


// Writeback mux (4 sources)
// 00=ALU result, 01=mem data, 10=PC+4 (JAL/JALR link), 11=imm (LUI)
reg [31:0] wb_data;
always @(*) begin
    case (wb_sel)
        2'b00: wb_data = alu_result;
        2'b01: wb_data = mem_data;
        2'b10: wb_data = pc_plus4;
        2'b11: wb_data = imm;
        default: wb_data = alu_result;
    endcase
end

assign writeback_data = wb_data;

endmodule
