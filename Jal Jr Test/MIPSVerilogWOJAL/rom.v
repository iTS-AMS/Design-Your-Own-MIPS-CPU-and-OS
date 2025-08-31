`timescale 1ns/1ns

module rom(
    input  [31:0] adr,
    output [31:0] dout
);

    parameter depth = 256;
    parameter width = 32;

    reg [width-1:0] Imem [0:depth-1];

    initial begin
        $display("Loading program from memfile.txt ...");
        $readmemb("memfile.txt", Imem);  // binary instructions
    end

    // Word addressing (ignore lower 2 bits)
    assign dout = Imem[adr[31:2]];

endmodule
