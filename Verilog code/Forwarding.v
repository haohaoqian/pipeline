`timescale 1ns / 1ps
module Forwarding(IDEX_Reg_Rs,IDEX_Reg_Rt,
                EXMEM_Reg_Rd,EXMEM_RegWrite,
                MEMWB_Reg_Rd,MEMWB_RegWrite,
                Forwarding_Ctrl1,Forwarding_Ctrl2);
    input [4:0] IDEX_Reg_Rs;
    input [4:0] IDEX_Reg_Rt;
    input [4:0] EXMEM_Reg_Rd;
    input EXMEM_RegWrite;
    input [4:0] MEMWB_Reg_Rd;
    input MEMWB_RegWrite;
    output [1:0] Forwarding_Ctrl1;
    output [1:0] Forwarding_Ctrl2;

    assign Forwarding_Ctrl1 = (EXMEM_RegWrite && (EXMEM_Reg_Rd != 0) && (EXMEM_Reg_Rd == IDEX_Reg_Rs))? 2'b10:
                              (MEMWB_RegWrite && (MEMWB_Reg_Rd != 0) && (MEMWB_Reg_Rd == IDEX_Reg_Rs) && ((EXMEM_Reg_Rd != IDEX_Reg_Rs)||(!EXMEM_RegWrite)))? 2'b01: 2'b00;
    assign Forwarding_Ctrl2 = (EXMEM_RegWrite && (EXMEM_Reg_Rd != 0) && (EXMEM_Reg_Rd == IDEX_Reg_Rt))? 2'b10:
                              (MEMWB_RegWrite && (MEMWB_Reg_Rd != 0) && (MEMWB_Reg_Rd == IDEX_Reg_Rt) && ((EXMEM_Reg_Rd != IDEX_Reg_Rt)||(!EXMEM_RegWrite)))? 2'b01: 2'b00;

endmodule