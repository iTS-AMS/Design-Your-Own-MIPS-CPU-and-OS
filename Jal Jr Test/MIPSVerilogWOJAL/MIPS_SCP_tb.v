`timescale 1ns/1ns

module MIPS_SCP_tb;

    // Inputs
    reg clk;
    reg reset;

    // Outputs from UUT
    wire [31:0] PC;
    wire [31:0] Instr;
    wire [31:0] ALUResult;
    wire [31:0] WriteData;
    wire [31:0] ReadData;
    wire RegWrite;

    // Instantiate Unit Under Test (UUT)
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
    initial clk = 0;
    always #50 clk = ~clk; // 100ns period

    // Monitor to display important signals
    initial begin
        $monitor("Time=%0t | PC=%h | Instr=%h | ALUResult=%h | WriteData=%h | ReadData=%h | RegWrite=%b", 
                  $time, PC, Instr, ALUResult, WriteData, ReadData, RegWrite);
    end

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        reset = 1;

        // Apply reset
        #100;
        reset = 0;

        // Run simulation long enough for JAL/JR execution
        #1000;

        // Check values in registers after function call
        $display("\n=== JAL/JR Test Results ===");
        $display("Register $a0 = %d (expected 5)", uut.datapathcomp.RF.register[4]);
        $display("Register $a1 = %d (expected 10)", uut.datapathcomp.RF.register[5]);
        $display("Register $v0 = %d (expected 15)", uut.datapathcomp.RF.register[2]);
        $display("Register $ra = %h (return address)", uut.datapathcomp.RF.register[31]);

        $finish;
    end

    // VCD file for waveform viewing
    initial begin
        $dumpfile("mips_scp_jal.vcd");
        $dumpvars(0, MIPS_SCP_tb);
    end

endmodule
