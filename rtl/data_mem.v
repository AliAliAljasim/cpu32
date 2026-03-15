module data_mem(
    input wire        clk,
    input wire        mem_write,
    input wire        mem_read,
    input wire [2:0]  funct3,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);

reg [31:0] memory [255:0];

wire [7:0]  word_addr = addr[9:2];
wire [1:0]  byte_off  = addr[1:0];

// Write: SW / SH / SB
always @(posedge clk) begin
    if (mem_write) begin
        case (funct3)
            3'b000: begin  // SB - store byte
                case (byte_off)
                    2'b00: memory[word_addr][ 7: 0] <= write_data[7:0];
                    2'b01: memory[word_addr][15: 8] <= write_data[7:0];
                    2'b10: memory[word_addr][23:16] <= write_data[7:0];
                    2'b11: memory[word_addr][31:24] <= write_data[7:0];
                endcase
            end
            3'b001: begin  // SH - store halfword
                case (byte_off[1])
                    1'b0: memory[word_addr][15: 0] <= write_data[15:0];
                    1'b1: memory[word_addr][31:16] <= write_data[15:0];
                endcase
            end
            default: memory[word_addr] <= write_data;  // SW - store word
        endcase
    end
end

// Read: LW / LH / LB / LHU / LBU
always @(*) begin
    if (mem_read) begin
        case (funct3)
            3'b000: begin  // LB - load byte, sign-extend
                case (byte_off)
                    2'b00: read_data = {{24{memory[word_addr][ 7]}}, memory[word_addr][ 7: 0]};
                    2'b01: read_data = {{24{memory[word_addr][15]}}, memory[word_addr][15: 8]};
                    2'b10: read_data = {{24{memory[word_addr][23]}}, memory[word_addr][23:16]};
                    2'b11: read_data = {{24{memory[word_addr][31]}}, memory[word_addr][31:24]};
                endcase
            end
            3'b001: begin  // LH - load halfword, sign-extend
                case (byte_off[1])
                    1'b0: read_data = {{16{memory[word_addr][15]}}, memory[word_addr][15: 0]};
                    1'b1: read_data = {{16{memory[word_addr][31]}}, memory[word_addr][31:16]};
                endcase
            end
            3'b010: read_data = memory[word_addr];  // LW - load word
            3'b100: begin  // LBU - load byte, zero-extend
                case (byte_off)
                    2'b00: read_data = {24'b0, memory[word_addr][ 7: 0]};
                    2'b01: read_data = {24'b0, memory[word_addr][15: 8]};
                    2'b10: read_data = {24'b0, memory[word_addr][23:16]};
                    2'b11: read_data = {24'b0, memory[word_addr][31:24]};
                endcase
            end
            3'b101: begin  // LHU - load halfword, zero-extend
                case (byte_off[1])
                    1'b0: read_data = {16'b0, memory[word_addr][15: 0]};
                    1'b1: read_data = {16'b0, memory[word_addr][31:16]};
                endcase
            end
            default: read_data = memory[word_addr];
        endcase
    end else
        read_data = 32'b0;
end

endmodule
