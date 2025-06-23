`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2024 18:41:10
// Design Name: 
// Module Name: MEM_WB
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

module MEM_WB (
    input  logic        clk, rst,
    
    // Input signals from MEM stage
    input  logic        RegWriteM,
    input  logic [1:0]  ResultSrcM,
    input  logic [31:0] AluResultM,
    input  logic [31:0] ReadDataM,
    input  logic [4:0]  RdM,
    input  logic [31:0] PCPlus4M,
    
    // Output signals to WB stage
    output logic        RegWriteW,
    output logic [1:0]  ResultSrcW,
    output logic [31:0] AluResultW,
    output logic [31:0] ReadDataW,
    output logic [4:0]  RdW,
    output logic [31:0] PCPlus4W
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs
            RegWriteW  <= 1'b0;
            ResultSrcW <= 2'b00;
            AluResultW <= 32'b0;
            ReadDataW  <= 32'b0;
            RdW        <= 5'b0;
            PCPlus4W   <= 32'b0;
        end else begin
            // Pass values from MEM stage to WB stage
            RegWriteW  <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            AluResultW <= AluResultM;
            ReadDataW  <= ReadDataM;
            RdW        <= RdM;
            PCPlus4W   <= PCPlus4M;
        end
    end

endmodule