`timescale 1ns/1ps

module cpu32_tb;

reg clk;
reg reset;

// Instantiate CPU
cpu32 uut (
    .clk(clk),
    .reset(reset)
);

// Clock generation (10ns period)
always #5 clk = ~clk;

initial begin

    // Initialize signals
    clk = 0;
    reset = 1;

    // Release reset after 20ns
    #20;
    reset = 0;

    // Run simulation for a while
    #200;


end

endmodule
