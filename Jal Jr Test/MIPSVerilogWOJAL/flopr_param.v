module flopr_param #(parameter n=32)(
    input clk, 
    input rst, 
    input [n-1:0] d, 
    output reg [n-1:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 0;       // reset immediately
        else
            q <= d;
    end

endmodule
