`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2024 21:45:05
// Design Name: 
// Module Name: X_Mem
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

module X_Mem (
    input  logic        clk, rst,
    
    // Input signals from EX stage
    input  logic        RegWriteE,        // 1-bit control signal for register write
    input  logic [1:0]  ResultSrcE,       // Control signal (2 bits to select source)
    input  logic [2:0]  MemWriteE,        // 3-bit control signal for memory write
    input  logic [2:0]  MemReadE,         // 3-bit control signal for memory read
    input  logic [4:0]  RdE,              // 5-bit destination register
    input  logic [31:0] PcPlus4E,         // 32-bit PC+4 value
    input  logic [31:0] alu_out,          // 32-bit ALU output
    input  logic [31:0] WriteDataE,       // 32-bit data to write to memory
    
    // Output signals to MEM stage
    output logic        RegWriteM,        // 1-bit control signal for register write
    output logic [1:0]  ResultSrcM,       // Control signal (2 bits to select source)
    output logic [2:0]  MemWriteM,        // 3-bit control signal for memory write
    output logic [2:0]  MemReadM,         // 3-bit control signal for memory read
    output logic [4:0]  RdM,              // 5-bit destination register
    output logic [31:0] PcPlus4M,         // 32-bit PC+4 value
    output logic [31:0] alu_outM,         // 32-bit ALU output
    output logic [31:0] WriteDataM        // 32-bit data to write to memory
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWriteM  <= 1'b0;
            ResultSrcM <= 2'b00;
            MemWriteM  <= 3'b000;
            MemReadM   <= 3'b000;
            RdM        <= 5'b0;
            PcPlus4M   <= 32'b0;
            alu_outM   <= 32'b0;
            WriteDataM <= 32'b0;
        end else begin
            RegWriteM  <= RegWriteE;
            ResultSrcM <= ResultSrcE;
            MemWriteM  <= MemWriteE;
            MemReadM   <= MemReadE;
            RdM        <= RdE;
            PcPlus4M   <= PcPlus4E;
            alu_outM   <= alu_out;
            WriteDataM <= WriteDataE;
        end
    end

endmodule