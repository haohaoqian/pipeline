`timescale 1ns / 1ps
module CPU(reset, pause, clk, DIGI ,LED);
    input clk;
    input reset;
    input pause;
    output [11:0] DIGI;
    output [7:0] LED;

    wire Hazard_Flush_Instruction;
    wire Hazard_Flush_Control;
    wire Hazard_Hold_PC;
    wire Hazard_Hold_IF_ID;

    wire Timer_Interrupt;

//IF stage
    reg [31:0] IF_PC;
    wire [31:0] IF_PC_next;
    wire [31:0] IF_PC_plus_4;
    wire [31:0] EX_PC_beq;
    wire [31:0] IF_PC_selected;
    wire [31:0] ID_PC_j;
    wire [31:0] ID_Databus1;
    wire EX_PC_branch_zero;
    wire [2:0] ID_PCSrc;
    wire [31:0] IF_Instruction_raw;
    wire [31:0] IF_Instruction;

    assign IF_PC_plus_4 = IF_PC + 32'd4;
    assign IF_PC_selected = (EX_PC_branch_zero == 1'b1)? EX_PC_beq: IF_PC_plus_4;
    assign IF_PC_next = (ID_PCSrc == 3'd0)? IF_PC_selected:
                        (ID_PCSrc == 3'd1)? ID_PC_j:
                        (ID_PCSrc == 3'd2)? ID_Databus1:
                        (ID_PCSrc == 3'd3)? 32'h80000004: 32'h80000008;
    assign IF_Instruction = (Hazard_Flush_Instruction == 0)? IF_Instruction_raw: 32'b0;

    always @(posedge reset or posedge clk)
    begin
        if (reset)
            IF_PC = 32'h80000000;
        else
        begin
            if (!Hazard_Hold_PC)
                IF_PC <= IF_PC_next;
        end
    end

    InstructionMemory instruction_memory1(.Address(IF_PC), .Instruction(IF_Instruction_raw));

//IF_ID register
    reg [31:0] IF_ID_PC_plus_4;
    reg [31:0] IF_ID_Instruction;

    always @(posedge reset or posedge clk)
    begin
        if (reset)
        begin
            IF_ID_PC_plus_4 <= 1'd0;
            IF_ID_Instruction <= 32'd0;
        end
        else
        begin
            if (Hazard_Flush_Instruction == 1)
            begin
                IF_ID_PC_plus_4 <= IF_PC_next+4;
                IF_ID_Instruction <= IF_Instruction;
            end
            else if (!Hazard_Hold_IF_ID)
            begin
                IF_ID_PC_plus_4 <= IF_PC_plus_4;
                IF_ID_Instruction <= IF_Instruction;
            end
        end
    end

//ID stage
    wire [31:0] ID_Instruction;
    wire [31:0] ID_Databus2;
    wire [31:0] WB_Databus;
    wire [4:0] WB_Write_register;
    wire WB_RegWrite;
    wire [31:0] WB_Databus_pre;
    wire [4:0] WB_Write_register_pre;
    wire WB_RegWrite_pre;
    wire [31:0] ID_Extend;
    wire [31:0] ID_Left16;
    wire [31:0] ID_16to32;
    wire [31:0] ID_PC_plus_4;
    wire [2:0] ID_BranchOp;
    wire ID_Branch;
    wire ID_RegWrite;
    wire [1:0] ID_RegDst;
    wire ID_MemRead;
    wire ID_MemWrite;
    wire [1:0] ID_MemtoReg;
    wire ID_ALUSrc1;
    wire ID_ALUSrc2;
    wire ID_ExtOp;
    wire ID_LuOp;
    wire [3:0] ID_ALUOp;
    wire ID_Exception;
    wire ID_PC_sign;

    assign ID_Instruction = IF_ID_Instruction;
    assign ID_Extend = {ID_ExtOp? {16{ID_Instruction[15]}}: 16'h0000, ID_Instruction[15:0]};
    assign ID_Left16 = {ID_Instruction[15:0],16'b0};
    assign ID_16to32 = (ID_LuOp == 0)? ID_Extend: ID_Left16;
    assign ID_PC_plus_4 = IF_ID_PC_plus_4;
    assign ID_PC_j = {ID_PC_plus_4[31:28],ID_Instruction[25:0],2'b00};
    assign ID_PC_sign = ID_PC_plus_4[31];

    RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(WB_RegWrite_pre), .Read_register1(ID_Instruction[25:21]), .Read_register2(ID_Instruction[20:16]), .Write_register(WB_Write_register_pre), .Write_data(WB_Databus_pre), .Read_data1(ID_Databus1), .Read_data2(ID_Databus2));

    Control control1(.OpCode(ID_Instruction[31:26]), .Funct(ID_Instruction[5:0]), .Interrupt(Timer_Interrupt), .PC_sign(ID_PC_sign), .PCSrc(ID_PCSrc), .Branch(ID_Branch), .RegWrite(ID_RegWrite), .RegDst(ID_RegDst), .MemRead(ID_MemRead), .MemWrite(ID_MemWrite), .MemtoReg(ID_MemtoReg), .ALUSrc1(ID_ALUSrc1), .ALUSrc2(ID_ALUSrc2), .ExtOp(ID_ExtOp), .LuOp(ID_LuOp), .ALUOp(ID_ALUOp), .BranchOp(ID_BranchOp), .Exception(ID_Exception));

    wire [1:0] ID_Forwarding_Ctrl1;
    wire [1:0] ID_Forwarding_Ctrl2;
    wire [4:0] EX_Write_register;
    wire [4:0] MEM_Write_register;
    wire MEM_RegWrite;
    wire EX_RegWrite;

    Forwarding forwarding1(.IDEX_Reg_Rs(ID_Instruction[25:21]),.IDEX_Reg_Rt(ID_Instruction[20:16]),.EXMEM_Reg_Rd(EX_Write_register),.EXMEM_RegWrite(EX_RegWrite),.MEMWB_Reg_Rd(MEM_Write_register),.MEMWB_RegWrite(MEM_RegWrite),.Forwarding_Ctrl1(ID_Forwarding_Ctrl1),.Forwarding_Ctrl2(ID_Forwarding_Ctrl2));

//ID_EX register
    reg [16:0] ID_EX_Control;
    reg [31:0] ID_EX_PC_plus_4;
    reg [4:0] ID_EX_Instruction_Shamt;
    reg [31:0] ID_EX_Databus1;
    reg [31:0] ID_EX_Databus2;
    reg [31:0] ID_EX_16to32;
    reg [5:0] ID_EX_Instruction_Funct;
    reg [4:0] ID_EX_Instruction_Rt;
    reg [4:0] ID_EX_Instruction_Rd;
    reg [3:0] ID_EX_Forwarding_Ctrl;

    always @(posedge reset or posedge clk)
    begin
        if (reset)
        begin
            ID_EX_Control <= 17'd0;
            ID_EX_PC_plus_4 <= 32'd0;
            ID_EX_Instruction_Shamt <= 5'd0;
            ID_EX_Databus1 <= 32'd0;
            ID_EX_Databus2 <= 32'd0;
            ID_EX_16to32 <= 32'd0;
            ID_EX_Instruction_Funct <= 6'd0;
            ID_EX_Instruction_Rt <= 5'd0;
            ID_EX_Instruction_Rd <= 5'd0;
            ID_EX_Forwarding_Ctrl <= 2'd0;
        end
        else
        begin
            if (Hazard_Flush_Control)
                ID_EX_Control <= 13'd0;
            else
            begin
                ID_EX_Control[16:14] <= ID_BranchOp;
                ID_EX_Control[13] <= ID_Branch;
                ID_EX_Control[12] <= ID_RegWrite;
                ID_EX_Control[11:10] <= ID_RegDst;
                ID_EX_Control[9] <= ID_MemRead;
                ID_EX_Control[8] <= ID_MemWrite;
                ID_EX_Control[7:6] <= ID_MemtoReg;
                ID_EX_Control[5] <= ID_ALUSrc1;
                ID_EX_Control[4] <= ID_ALUSrc2;
                ID_EX_Control[3:0] <= ID_ALUOp;
            end
            ID_EX_PC_plus_4 <= ID_PC_plus_4;
            ID_EX_Instruction_Shamt <= ID_Instruction[10:6];
            ID_EX_Databus1 <= ID_Databus1;
            ID_EX_Databus2 <= ID_Databus2;
            ID_EX_16to32 <= ID_16to32;
            ID_EX_Instruction_Funct <= ID_Instruction[5:0];
            ID_EX_Instruction_Rt <= ID_Instruction[20:16];
            ID_EX_Instruction_Rd <= ID_Instruction[15:11];
            ID_EX_Forwarding_Ctrl <= {ID_Forwarding_Ctrl1, ID_Forwarding_Ctrl2};
        end
    end

//EX stage
    wire [3:0] EX_ALUOp;
    wire [2:0] EX_BranchOp;
    wire EX_ALUSrc1;
    wire EX_ALUSrc2;
    wire [1:0] EX_RegDst;
    wire EX_Branch;
    wire EX_MemRead;
    wire [4:0] EX_Control;

    assign EX_ALUOp = ID_EX_Control[3:0];
    assign EX_BranchOp = ID_EX_Control[16:14];
    assign EX_ALUSrc1 = ID_EX_Control[5];
    assign EX_ALUSrc2 = ID_EX_Control[4];
    assign EX_RegDst = ID_EX_Control[11:10];
    assign EX_Branch = ID_EX_Control[13];
    assign EX_MemRead = ID_EX_Control[9];
    assign EX_Control = {ID_EX_Control[9:6],ID_EX_Control[12]};
    assign EX_RegWrite = ID_EX_Control[12];

    wire [31:0] EX_PC_plus_4;
    wire [4:0] EX_Instruction_Shamt;
    wire [31:0] EX_Databus1;
    wire [31:0] EX_Databus2;
    wire [31:0] EX_16to32;
    wire [5:0] EX_Instruction_Funct;
    wire [4:0] EX_Instruction_Rt;
    wire [4:0] EX_Instruction_Rd;

    assign EX_PC_plus_4 = ID_EX_PC_plus_4;
    assign EX_Instruction_Shamt = ID_EX_Instruction_Shamt;
    assign EX_Databus1 = ID_EX_Databus1;
    assign EX_Databus2 = ID_EX_Databus2;
    assign EX_16to32 = ID_EX_16to32;
    assign EX_Instruction_Funct = ID_EX_Instruction_Funct;
    assign EX_Instruction_Rt = ID_EX_Instruction_Rt;
    assign EX_Instruction_Rd = ID_EX_Instruction_Rd;
    assign EX_Write_register = (EX_RegDst == 2'b00)? EX_Instruction_Rt:
                               (EX_RegDst == 2'b01)? EX_Instruction_Rd:
                               (EX_RegDst == 2'b10)? 5'd31: 5'd26;

    wire [31:0] EX_ALU_in1;
    wire [31:0] EX_ALU_prein1;
    wire [31:0] EX_ALU_in2;
    wire [31:0] EX_ALU_prein2;
    wire [4:0] EX_ALUCtl;
    wire EX_Sign;
    wire [31:0] EX_ALU_out;
    wire EX_Zero;
    wire [1:0] EX_Forwarding_Ctrl1;
    wire [1:0] EX_Forwarding_Ctrl2;
    wire [31:0] MEM_ALU_out;
    wire EX_Interrupt;
    wire EX_Exception;

    assign EX_Forwarding_Ctrl1 = ID_EX_Forwarding_Ctrl[3:2];
    assign EX_Forwarding_Ctrl2 = ID_EX_Forwarding_Ctrl[1:0];
    assign EX_ALU_prein1 = (EX_Forwarding_Ctrl1 == 2'b00)? EX_Databus1:
                           (EX_Forwarding_Ctrl1 == 2'b01)? WB_Databus: MEM_ALU_out;
    assign EX_ALU_prein2 = (EX_Forwarding_Ctrl2 == 2'b00)? EX_Databus2:
                           (EX_Forwarding_Ctrl2 == 2'b01)? WB_Databus: MEM_ALU_out;
    assign EX_ALU_in1 = (EX_ALUSrc1 == 0)? EX_ALU_prein1: {17'h00000, EX_Instruction_Shamt};
    assign EX_ALU_in2 = (EX_ALUSrc2 == 0)? EX_ALU_prein2: EX_16to32;

    ALUControl alu_control1(.ALUOp(EX_ALUOp), .Funct(EX_Instruction_Funct), .ALUCtl(EX_ALUCtl), .Sign(EX_Sign));
    ALU alu1(.in1(EX_ALU_in1), .in2(EX_ALU_in2), .ALUCtl(EX_ALUCtl), .Sign(EX_Sign), .out(EX_ALU_out));
    Branch branch1(.in1(EX_ALU_prein1), .in2(EX_ALU_prein2), .BranchOp(EX_BranchOp), .zero(EX_Zero));

    assign EX_PC_branch_zero = EX_Branch && EX_Zero;
    assign EX_PC_beq = EX_PC_plus_4 + {EX_16to32[29:0], 2'b00};

    Hazard hazard1(.OpCode(ID_Instruction[31:26]), .Funct(ID_Instruction[5:0]), .Exception(ID_Exception), .Branch_and_Zero(EX_PC_branch_zero), .IDEX_MemRead(EX_MemRead), .IDEX_Reg_Rt(EX_Instruction_Rt), .IFID_Reg_Rs(ID_Instruction[25:21]), .IFID_Reg_Rt(ID_Instruction[20:16]), .pause(pause), .Flush_Instruction(Hazard_Flush_Instruction), .Flush_Control(Hazard_Flush_Control), .Hold_PC(Hazard_Hold_PC), .Hold_IF_ID(Hazard_Hold_IF_ID));

//EX_MEM register
    reg [4:0] EX_MEM_Control;
    reg [31:0] EX_MEM_PC_plus_4;
    reg [31:0] EX_MEM_ALU_out;
    reg [31:0] EX_MEM_Databus2;
    reg [4:0] EX_MEM_Write_register;

    always @(posedge reset or posedge clk)
    begin
        if (reset)
        begin
            EX_MEM_Control <= 6'd0;
            EX_MEM_PC_plus_4 <= 32'd0;
            EX_MEM_ALU_out <= 32'd0;
            EX_MEM_Databus2 <= 32'd0;
            EX_MEM_Write_register <= 5'd0;
        end
        else
        begin
            EX_MEM_Control <= EX_Control;
            EX_MEM_PC_plus_4 <= EX_PC_plus_4;
            EX_MEM_ALU_out <= EX_ALU_out;
            EX_MEM_Databus2 <= EX_ALU_prein2;
            EX_MEM_Write_register <= EX_Write_register;
        end
    end

//MEM stage
    wire MEM_MemRead;
    wire MEM_MemWrite;
    wire [1:0] MEM_MemtoReg;

    assign MEM_MemRead = EX_MEM_Control[4];
    assign MEM_MemWrite = EX_MEM_Control[3];
    assign MEM_MemtoReg = EX_MEM_Control[2:1];
    assign MEM_RegWrite = EX_MEM_Control[0];

    wire [31:0] MEM_PC_plus_4;
    wire [31:0] MEM_Databus2;
    wire [31:0] MEM_Read_data;

    assign MEM_PC_plus_4 = EX_MEM_PC_plus_4;
    assign MEM_ALU_out = EX_MEM_ALU_out;
    assign MEM_Databus2 = EX_MEM_Databus2;
    assign MEM_Write_register = EX_MEM_Write_register;

    DataMemory data_memory1(.reset(reset), .clk(clk), .Address(MEM_ALU_out), .Write_data(MEM_Databus2), .MemRead(MEM_MemRead), .MemWrite(MEM_MemWrite), .Read_data(MEM_Read_data), .Interrupt(Timer_Interrupt), .digi_out(DIGI), .led_out(LED));

    wire [31:0] MEM_Databus;
    
    assign MEM_Databus =(MEM_MemtoReg == 2'd0)? MEM_ALU_out:
                        (MEM_MemtoReg == 2'd1)? MEM_Read_data: 
                        (MEM_MemtoReg == 2'd3)? MEM_PC_plus_4-4:
                        MEM_PC_plus_4;
                
    reg [31:0] MEM_Databus_reg;
    
    always @(*)
    begin
        if(reset)
        begin
            MEM_Databus_reg <= 32'd0;
        end
        else
        begin
            MEM_Databus_reg <= MEM_Databus;
        end
    end
    
    reg MEM_RegWrite_reg;
    reg [4:0] MEM_Write_register_reg;
    
    always @(posedge reset or negedge clk)
    begin
        if(reset)
        begin
            MEM_RegWrite_reg <= 1'd0;
            MEM_Write_register_reg <= 5'd0;
        end
        else
        begin
            MEM_RegWrite_reg <= MEM_RegWrite;
            MEM_Write_register_reg <= MEM_Write_register;
        end
    end

//MEM_WB register
    reg [31:0] MEM_WB_Databus;

    always @(posedge reset or posedge clk)
    begin
        if (reset)
        begin
            MEM_WB_Databus <= 32'd0;
        end
        else
        begin
            MEM_WB_Databus <= MEM_Databus;
        end
    end

//WB stage
    assign WB_Databus = MEM_WB_Databus;

    assign WB_Databus_pre = MEM_Databus_reg;
    assign WB_Write_register_pre = MEM_Write_register_reg;
    assign WB_RegWrite_pre = MEM_RegWrite_reg;

endmodule