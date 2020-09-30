`timescale 1ns / 1ps
module Hazard(OpCode, Funct, Exception, Branch_and_Zero, IDEX_MemRead,
              IDEX_Reg_Rt, IFID_Reg_Rs, IFID_Reg_Rt, pause,
              Flush_Instruction, Flush_Control, Hold_PC, Hold_IF_ID);
    input [5:0] OpCode;
    input [5:0] Funct;
    input Exception;
    input Branch_and_Zero;
    input IDEX_MemRead;
    input [4:0] IDEX_Reg_Rt;
    input [4:0] IFID_Reg_Rs;
    input [4:0] IFID_Reg_Rt;
    input pause;
    output Flush_Instruction;
    output Flush_Control;
    output Hold_PC;
    output Hold_IF_ID;

    assign Flush_Instruction = pause || ((Exception || Branch_and_Zero || (OpCode == 6'h02) || (OpCode == 6'h03) || (OpCode == 6'h00 && ((Funct == 6'h08) || (Funct == 6'h09))))? 1'b1: 1'b0);
    assign Flush_Control = ((IDEX_MemRead && ((IDEX_Reg_Rt == IFID_Reg_Rs) || (IDEX_Reg_Rt == IFID_Reg_Rt))) || Branch_and_Zero)? 1'b1: 1'b0;
    assign Hold_PC = pause || ((IDEX_MemRead && ((IDEX_Reg_Rt == IFID_Reg_Rs) || (IDEX_Reg_Rt == IFID_Reg_Rt)))? 1'b1: 1'b0);
    assign Hold_IF_ID = (IDEX_MemRead && ((IDEX_Reg_Rt == IFID_Reg_Rs) || (IDEX_Reg_Rt == IFID_Reg_Rt)))? 1'b1: 1'b0;

endmodule