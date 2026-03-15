module branch_unit(
    input wire        branch,
    input wire [2:0]  funct3,
    input wire        zero,
    input wire        lt,
    input wire        ltu,
    output wire       take_branch
);

reg condition;

always @(*) begin
    case (funct3)
        3'b000: condition = zero;   // BEQ
        3'b001: condition = ~zero;  // BNE
        3'b100: condition = lt;     // BLT
        3'b101: condition = ~lt;    // BGE
        3'b110: condition = ltu;    // BLTU
        3'b111: condition = ~ltu;   // BGEU
        default: condition = 1'b0;
    endcase
end

assign take_branch = branch & condition;

endmodule
