`timescale 1ns / 1ps
module DataMemory(reset, clk, Address, Write_data, MemRead, MemWrite, Read_data, Interrupt, digi_out, led_out);
    input reset, clk;
    input [31:0] Address, Write_data;
    input MemRead, MemWrite;
    output [31:0] Read_data;
    output Interrupt;
    output [11:0] digi_out;
    output [7:0] led_out;
    reg Interrupt;

    parameter RAM_SIZE = 128;
    parameter RAM_SIZE_BIT = 8;

    reg [31:0] RAM_data[RAM_SIZE - 1: 0];
    reg [31:0] TH;
    reg [31:0] TL;
    reg [31:0] TCON;
    reg [31:0] led;
    reg [31:0] digi;
    reg [31:0] systick;
    
    assign Read_data = (MemRead)? ((Address == 32'h40000000)? TH:
                                   (Address == 32'h40000004)? TL:
                                   (Address == 32'h40000008)? {29'b0,TCON}:
                                   (Address == 32'h4000000C)? {24'b0,led}:
                                   (Address == 32'h40000010)? {20'b0,digi}:
                                   (Address == 32'h40000014)? systick:
                                   RAM_data[Address[RAM_SIZE_BIT + 1:2]]):
                       32'h00000000;
    assign digi_out = digi[11:0];
    assign led_out = led[7:0];

    integer i;
    always@(posedge reset or posedge clk)
    begin
        if (reset)
        begin
            for (i = 0; i < RAM_SIZE; i = i + 1)
                RAM_data[i] <= 32'h00000000;
            TH <= 32'h00000000;
            TL <= 32'h00000000;
            TCON <= 3'd0;
            led <= 8'd0;
            digi <= 12'hfff;
            systick <= 32'd0;
            Interrupt <= 1'd0;
        end
        else
        begin
            systick <= systick + 1;
            if(MemWrite)
            begin
                case(Address)
                    32'h40000000:TH <= Write_data;
                    32'h40000004:TL <= Write_data;
                    32'h40000008:TCON <= {29'b0,Write_data[2:0]};
                    32'h4000000C:led <= {24'b0,Write_data[7:0]};
                    32'h40000010:digi <= {20'b0,Write_data[11:0]};
                    default:     RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
                endcase
            end
            if (TCON[0])
            begin
                if(TL==32'hffffffff)
                begin
                    TL <= TH;
                    if(TCON[1])
                    begin
                        TCON[2] <= 1'b1;
                        Interrupt <= 1'b1;
                    end
                end
                else
                begin
                    TL <=TL +1;
                    Interrupt <= 1'b0;
                end
            end
        end
    end
endmodule