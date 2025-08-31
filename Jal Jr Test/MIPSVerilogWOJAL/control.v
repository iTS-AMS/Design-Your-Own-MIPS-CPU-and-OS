// Control Unit with JAL and JR support
`timescale 1ns/1ns

module ControlUnit(
    input [5:0] Opcode, 
    input [5:0] Func,
    input Zero,
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegDst,
    output reg RegWrite,
    output reg Jump,
    output reg Jal,
    output reg Jr,
    output PCSrc,
    output reg [3:0] ALUControl
);
               
reg [9:0] temp;
reg Branch, BNE;

always @(*) begin 
    // Default values
    temp = 10'b0;
    ALUControl = 4'b0;
    Jal = 1'b0;
    Jr = 1'b0;
    Branch = 1'b0;
    BNE = 1'b0;
    
    case (Opcode) 
        6'b000000: begin                          // R-type
            case (Func)
                6'b100000: begin                 // ADD
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0000;
                end
                6'b100001: begin                 // ADDU
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0000;
                end
                6'b100010: begin                 // SUB
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0001;
                end
                6'b100011: begin                 // SUBU
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0001;
                end
                6'b100100: begin                 // AND
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0010;
                end
                6'b100101: begin                 // OR
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0011;
                end
                6'b100110: begin                 // XOR
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0100;
                end
                6'b100111: begin                 // NOR
                    temp = 10'b1100000000;        
                    ALUControl = 4'b1010;
                end
                6'b101010: begin                 // SLT
                    temp = 10'b1100000000;        
                    ALUControl = 4'b1000;
                end
                6'b101011: begin                 // SLTU
                    temp = 10'b1100000000;        
                    ALUControl = 4'b1001;
                end
                6'b000000: begin                 // SLL
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0101;
                end
                6'b000010: begin                 // SRL
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0110;
                end
                6'b000011: begin                 // SRA
                    temp = 10'b1100000000;        
                    ALUControl = 4'b0111;
                end
                6'b000100: begin                 // SLLV
                    temp = 10'b1100000000;        
                    ALUControl = 4'b1011;
                end
                6'b000110: begin                 // SRLV
                    temp = 10'b1100000000;        
                    ALUControl = 4'b1100;
                end
                6'b000111: begin                 // SRAV
                    temp = 10'b1100000000;        
                    ALUControl = 4'b1101;
                end
                6'b001000: begin                 // JR
                    temp = 10'b0000000001;        
                    ALUControl = 4'b0000;
                    Jr = 1'b1;
                end
                default: begin
                    temp = 10'b0000000000;
                    ALUControl = 4'b0000;
                end
            endcase
        end

        6'b100011: begin                         // LW
            temp = 10'b1010010000;     
            ALUControl = 4'b0000;
        end

        6'b101011: begin                         // SW
            temp = 10'b0010100000;      
            ALUControl = 4'b0000;
        end  

        6'b000100: begin                         // BEQ
            temp = 10'b0001000000;      
            ALUControl = 4'b0001;
            Branch = 1'b1;
        end      

        6'b000101: begin                         // BNE
            temp = 10'b0001000000;  
            ALUControl = 4'b0001;
            Branch = 1'b1;
            BNE = 1'b1;
        end

        6'b001000: begin                         // ADDI
            temp = 10'b1010000000;  
            ALUControl = 4'b0000; 
        end  

        6'b001001: begin                         // ADDIU
            temp = 10'b1010000000;  
            ALUControl = 4'b0000; 
        end  

        6'b001100: begin                         // ANDI
            temp = 10'b1010000000;  
            ALUControl = 4'b0010; 
        end 

        6'b001101: begin                         // ORI
            temp = 10'b1010000000;  
            ALUControl = 4'b0011; 
        end  

        6'b001110: begin                         // XORI
            temp = 10'b1010000000;  
            ALUControl = 4'b0100; 
        end       

        6'b001010: begin                         // SLTI
            temp = 10'b1010000000;  
            ALUControl = 4'b1000; 
        end 

        6'b001011: begin                         // SLTIU
            temp = 10'b1010000000;  
            ALUControl = 4'b1001; 
        end  

        6'b000010: begin                         // J
            temp = 10'b0000001000;  
            ALUControl = 4'b0000;
            Jump = 1'b1;
        end 
        
        6'b000011: begin                         // JAL
            temp = 10'b1000001000;  
            ALUControl = 4'b0000;
            Jump = 1'b1;
            Jal = 1'b1;
        end
                        
        6'b001111: begin                         // LUI
            temp = 10'b1010000000;  
            ALUControl = 4'b1110; 
        end          
        
        default: begin                           // NOP
            temp = 10'b0000000000;
            ALUControl = 4'b0000;
        end
    endcase
   
    // Use blocking assignment for the concatenation
    {RegWrite, RegDst, ALUSrc, MemWrite, MemtoReg, Jump} = temp[9:4];
end 

assign PCSrc = Branch & (Zero ^ BNE);

endmodule