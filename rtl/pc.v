module pc(
    input wire        clk,
    input wire        reset,
    input wire        pc_sel,        // 1 = load jump_target, 0 = PC+4
    input wire [31:0] jump_target,   // branch target or jump target
    output reg [31:0] pc
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'b0;
    else if (pc_sel)
        pc <= jump_target;
    else
        pc <= pc + 4;
end

endmodule
