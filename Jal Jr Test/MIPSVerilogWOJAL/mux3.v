// file: mux3.v
`timescale 1ns/1ns

module mux3 #(parameter WIDTH=32) (
    input [WIDTH-1:0] d0, d1, d2,
    input [1:0] s,
    output reg [WIDTH-1:0] y
);
    always @(*)
        case(s)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            default: y = d0;
        endcase
endmodule