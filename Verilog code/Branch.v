`timescale 1ns / 1ps
module Branch(in1, in2, BranchOp, zero);
    input [31:0] in1, in2;
    input [2:0] BranchOp;
    output zero;

    assign zero = (BranchOp == 3'b001)? (in1 == in2):
                  (BranchOp == 3'b010)? (in1 != in2):
                  (BranchOp == 3'b011)? ((in1 == 32'd0) || (in1[31] == 1'b1)):
                  (BranchOp == 3'b100)? ((in1 != 32'd0) || (in1[31] == 1'b0)):
                  (BranchOp == 3'b101)? (in1[31] == 1'b1):
                  1'b0;

endmodule