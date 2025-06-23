`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2024 19:00:14
// Design Name: 
// Module Name: WB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module WB (
    input  logic [1:0]  ResultSrcW,
    input  logic [31:0] AluResultW,
    input  logic [31:0] ReadDataW,
    input  logic [4:0]  RdW,
    input  logic [31:0] PCPlus4W,
    output logic [31:0] ResultW
);
    
    always_comb begin
        case (ResultSrcW)
            2'b00: ResultW = AluResultW;
            2'b01: ResultW = ReadDataW;
            2'b10: ResultW = PCPlus4W;
            default: ResultW = 32'b0;
        endcase
    end 

endmodule