module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_op,
    input  wire [2:0]  funct3,
    input  wire [6:0]  funct7,

    output reg  [31:0] result,
    output wire        zero,
    output wire        lt,
    output wire        ltu
);

always @(*) begin

    case (alu_op)

        // Arithmetic / Logic group (used by R-type, I-type ALU, loads, stores, branches, AUIPC, JALR)
        4'b0000: begin
            case (funct3)

                3'b000: begin
                    if (funct7 == 7'b0100000)
                        result = a - b;           // SUB
                    else
                        result = a + b;           // ADD / ADDI
                end

                3'b111: result = a & b;           // AND / ANDI
                3'b110: result = a | b;           // OR  / ORI
                3'b100: result = a ^ b;           // XOR / XORI

                3'b010: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT / SLTI

                3'b011: result = (a < b) ? 32'd1 : 32'd0;                   // SLTU / SLTIU

                // SHIFT LEFT
                3'b001: result = a << b[4:0];     // SLL / SLLI

                // SHIFT RIGHT
                3'b101: begin
                    if (funct7 == 7'b0100000)
                        result = $signed(a) >>> b[4:0]; // SRA / SRAI
                    else
                        result = a >> b[4:0];           // SRL / SRLI
                end

                default: result = 32'b0;

            endcase
        end

        default: result = a + b;

    endcase

end

assign zero = (result == 32'b0);
assign lt   = ($signed(a) < $signed(b));
assign ltu  = (a < b);

endmodule
