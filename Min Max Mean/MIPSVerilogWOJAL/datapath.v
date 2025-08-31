// file: Datapath.v
`include "adder.v"
`include "alu32.v"
`include "flopr_param.v"
`include "mux2.v"
`include "mux4.v"
`include "regfile32.v"
`include "signext.v"
`include "sl2.v"

`timescale 1ns/1ns

module Datapath(input clk,
                input reset,
                input RegDst,
                input RegWrite,
                input ALUSrc,
                input Jump,
                input Jal,
                input Jr,
                input MemtoReg,
                input PCSrc,
                input [3:0] ALUControl,
                input [31:0] ReadData,
                input [31:0] Instr,
                output [31:0] PC,
                output ZeroFlag,
                output [31:0] datatwo, 
                output [31:0] ALUResult);

wire [31:0] PCNext, PCplus4, PCbeforeBranch, PCBranch;
wire [31:0] extendedimm, extendedimmafter, MUXresult, dataone, aluop2;
wire [4:0] writereg;
wire [31:0] PCNextFinal;

// PC Logic
flopr_param #(32) PCregister(clk, reset, PCNextFinal, PC);
adder #(32) pcadd4(PC, 32'd4, PCplus4);
slt2 shifteradd2(extendedimm, extendedimmafter);
adder #(32) pcaddsigned(extendedimmafter, PCplus4, PCbeforeBranch);
mux2 #(32) branchmux(PCplus4, PCbeforeBranch, PCSrc, PCBranch);
mux2 #(32) jumpmux(PCBranch, {PCplus4[31:28], Instr[25:0], 2'b00}, Jump, PCNext);

// JR MUX - Select between normal next PC and register value for JR
mux2 #(32) jrmux(PCNext, dataone, Jr, PCNextFinal);

// Register File 
// Register File 
registerfile32 RF(
    .clk(clk),
    .we(RegWrite),
    .reset(reset),
    .ra1(Instr[25:21]),
    .ra2(Instr[20:16]),
    .wa(writereg),
    .wd(MUXresult),
    .rd1(dataone),
    .rd2(datatwo)
);


// Write register selection MUX
mux4 #(5) write_reg_mux(
    .d0(Instr[20:16]),  // rt (I-type)
    .d1(Instr[15:11]),  // rd (R-type)
    .d2(5'b11111),      // $ra (for JAL)
    .d3(5'b00000),      // unused
    .s({Jal, RegDst}),
    .y(writereg)
);

// Write data selection MUX
mux4 #(32) result_mux(
    .d0(ALUResult),     // ALU result
    .d1(ReadData),      // Memory read data
    .d2(PCplus4),       // Return address (for JAL)
    .d3(32'h00000000),  // unused
    .s({Jal, MemtoReg}),
    .y(MUXresult)
);

// ALU
alu32 alucomp(
    .a(dataone),
    .b(aluop2),
    .f(ALUControl),       // match "f"
    .shamt(Instr[10:6]),
    .y(ALUResult),        // match "y"
    .zero(ZeroFlag)
);

signext immextention(Instr[15:0], extendedimm);
mux2 #(32) aluop2sel(datatwo, extendedimm, ALUSrc, aluop2);

endmodule