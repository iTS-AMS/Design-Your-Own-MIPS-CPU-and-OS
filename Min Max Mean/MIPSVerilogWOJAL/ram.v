`timescale 1ns/1ns

module ram(
    input clk,
    input we,
    input [31:0] adr,
    input [31:0] din,
    output [31:0] dout
);

    parameter depth = 128;
    parameter width = 32;

    reg [width-1:0] Dmem [0:depth-1];

    // word addressing (ignore adr[1:0])
    assign dout = Dmem[adr[31:2]];

    initial begin
        $display("Loading data memory from data.txt ...");
        $readmemb("dmem.txt", Dmem);
    end

    always @(posedge clk) begin
        if (we)
            Dmem[adr[31:2]] <= din;
    end

endmodule
