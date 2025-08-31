`timescale 1ns/1ns

module MIPS_SCP(
    input clk,
    input reset,
    output [31:0] PC,
    output [31:0] Instr,
    output [31:0] ALUResult,
    output [31:0] WriteData,
    output [31:0] ReadData,
    output RegWrite
);
    
    wire RegDst, ALUSrc, Jump, Jal, Jr, MemtoReg, PCSrc, Zero, MemWrite;
    wire [3:0] ALUControl;
    
    Datapath datapathcomp(
        .clk(clk),
        .reset(reset),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .Jump(Jump),
        .Jal(Jal),
        .Jr(Jr),
        .MemtoReg(MemtoReg),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl),
        .ReadData(ReadData),
        .Instr(Instr),
        .PC(PC),
        .ZeroFlag(Zero),
        .datatwo(WriteData),
        .ALUResult(ALUResult)
    );
    
    ControlUnit controller(
        .Opcode(Instr[31:26]),
        .Func(Instr[5:0]),
        .Zero(Zero),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .Jal(Jal),
        .Jr(Jr),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl)
    );
    
    ram dmem(
        .clk(clk),
        .we(MemWrite),
        .adr(ALUResult),
        .din(WriteData),
        .dout(ReadData)
    );
    
    rom imem(
        .adr(PC),
        .dout(Instr)
    );
    
endmodule
