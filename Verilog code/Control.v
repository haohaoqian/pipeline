`timescale 1ns / 1ps
module Control(OpCode, Funct, Interrupt, PC_sign,
    PCSrc, Branch, RegWrite, RegDst, 
    MemRead, MemWrite, MemtoReg, 
    ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUOp, BranchOp, Exception);
    input [5:0] OpCode;
    input [5:0] Funct;
    input Interrupt;
    input PC_sign;
    output [2:0] PCSrc;
    output Branch;
    output RegWrite;
    output [1:0] RegDst;
    output MemRead;
    output MemWrite;
    output [1:0] MemtoReg;
    output ALUSrc1;
    output ALUSrc2;
    output ExtOp;
    output LuOp;
    output [3:0] ALUOp;
    output [2:0] BranchOp;
    output Exception;

    wire Exception_inside;

    assign Exception_inside = ((OpCode == 6'h00 && (Funct == 6'h20 || Funct == 6'h21 || Funct == 6'h22 || Funct == 6'h23 || Funct == 6'h24 || Funct == 6'h25 || Funct == 6'h26 || Funct == 6'h27 || Funct == 6'h02 || Funct == 6'h03 || Funct == 6'h2a || Funct == 6'h08 || Funct == 6'h09 || Funct == 6'h00)) || (OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0d || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01 || OpCode == 6'h02 || OpCode == 6'h03 || OpCode == 6'h04 || OpCode == 6'h0a || OpCode == 6'h0b))? 1'b0:
    1'b1;
    assign Exception = (!PC_sign) && (Interrupt || Exception_inside);
    assign PCSrc =
        ((!PC_sign) && Exception_inside == 1'b1)? 3'd4:
        ((!PC_sign) && Interrupt == 1'b1)? 3'd3:
        (OpCode == 6'h02 || OpCode == 6'h03)? 3'd1:
        (OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09))? 3'd2:
        3'd0;
    assign Branch =
        (Exception == 1'b1)? 1'b0:        
        (OpCode == 6'h01 || OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07)? 1'b1:
        1'b0;
    assign RegWrite =
        (Exception == 1'b1)? 1'b1:
        (OpCode == 6'h2b || OpCode == 6'h01 || OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h02 || (OpCode == 6'h00 && Funct == 6'h08))? 1'b0:
        1'b1;
    assign RegDst =
        (Exception == 1'b1)? 2'd3:
        (OpCode == 6'h00)? 2'd1:
        (OpCode == 6'h03)? 2'd2:
        2'd0;
    assign MemRead =
        (Exception == 1'b1)? 1'b0:
        (OpCode == 6'h23)? 1'b1:
        1'b0;
    assign MemWrite =
        (Exception == 1'b1)? 1'b0:
        (OpCode == 6'h2b)? 1'b1:
        1'b0;
    assign MemtoReg =
        (Interrupt == 1'b1)? 2'd3:
        (Exception_inside == 1'b1)? 2'd2:
        (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))? 2'd2:
        (OpCode == 6'h23)? 2'd1:
        2'd0;
    assign ALUSrc1 =
        (OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03))? 1'b1:
        1'b0;
    assign ALUSrc2 =
        (OpCode == 6'h00 || OpCode == 6'h01 || OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h07)? 1'b0:
        1'b1;
    assign ExtOp =
        (OpCode == 6'h0c || OpCode == 6'h0d)? 1'b0:
        1'b1;
    assign LuOp =
        (OpCode == 6'h0f)? 1'b1:
        1'b0;

    assign ALUOp[2:0] = 
        (OpCode == 6'h00)? 3'b010: 
        (OpCode == 6'h0c)? 3'b100: 
        (OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 
        3'b000;

    assign ALUOp[3] = OpCode[0];

    assign BranchOp = 
        (OpCode == 6'h04)? 3'b001:
        (OpCode == 6'h05)? 3'b010:
        (OpCode == 6'h06)? 3'b011:
        (OpCode == 6'h07)? 3'b100:
        (OpCode == 6'h01)? 3'b101:
        3'b000;

endmodule