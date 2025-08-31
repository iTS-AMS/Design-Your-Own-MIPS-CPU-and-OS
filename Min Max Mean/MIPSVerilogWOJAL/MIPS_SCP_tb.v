`timescale 1ns/1ns

module MIPS_SCP_tb;

    // Inputs
    reg clk;
    reg reset;

    // Outputs from uut
    wire [31:0] PC;
    wire [31:0] Instr;
    wire [31:0] ALUResult;
    wire [31:0] WriteData;
    wire [31:0] ReadData;
    wire RegWrite;

    // Instantiation of Unit Under Test
    MIPS_SCP uut (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData),
        .RegWrite(RegWrite)
    );

    // Clock generation
    always #50 clk = ~clk;

    // Monitor to display important signals
    initial begin
        $monitor("Time=%0t PC=%h Instr=%h ALUResult=%h WriteData=%h ReadData=%h RegWrite=%b", 
                 $time, PC, Instr, ALUResult, WriteData, ReadData, RegWrite);
    end

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        
        // Apply reset
        #100;
        reset = 0;
        
        // Run for enough cycles to execute the program
        #10000;
        
        // Display final results
        $display("\n=== Min/Max/Avg Results ===");
        $display("Expected: Min=1, Max=10, Sum=55, Avg=5");
        $display("Actual Results:");
        $display("Register $s0 (Min): %d", uut.datapathcomp.RF.register[16]); // $s0 = reg16
        $display("Register $s1 (Max): %d", uut.datapathcomp.RF.register[17]); // $s1 = reg17
        $display("Register $s2 (Sum): %d", uut.datapathcomp.RF.register[18]); // $s2 = reg18
        $display("Register $s3 (Avg): %d", uut.datapathcomp.RF.register[19]); // $s3 = reg19
        
        $finish;
    end

    // VCD file generation for waveform viewing
    initial begin
        $dumpfile("mips_scp.vcd");
        $dumpvars(0, MIPS_SCP_tb);
    end

endmodule
