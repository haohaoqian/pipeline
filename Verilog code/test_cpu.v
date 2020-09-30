`timescale 1ns / 1ps
module test_cpu();

    reg reset;
    reg pause;
    reg clk;
    wire [11:0] DIGI;
    wire [7:0] LED;

    CPU cpu1(reset, pause, clk, DIGI, LED);

    initial begin
        reset = 0;
        clk = 0;
        pause = 0;
        #5 reset = 1;
        #8 reset = 0;
        #60000 $finish;
    end

    always #5 clk = ~clk;

endmodule
