`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2024 17:40:53
// Design Name: 
// Module Name: if_id
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

module if_id (
    input  logic        clk,              // Clock signal
    input  logic        rst,              // Reset signal
    input  logic        StallD,           // Control signal to stall the pipeline
    input  logic        FlushD,           // Control signal to flush the pipeline
    input  logic [31:0] PCF,              // Program counter input
    input  logic [31:0] PCPlus4F,         // Program counter + 4 input
    input  logic [31:0] instrF,           // Instruction input
    
    output logic [31:0] PCD,              // Program counter output
    output logic [31:0] PCPlus4D,         // Program counter + 4 output
    output logic [31:0] instrD            // Instruction output
);

    // Sequential logic for the IF/ID register
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // On reset, clear the outputs
            PCD      <= 32'b0;
            PCPlus4D <= 32'b0;
            instrD   <= 32'b0;
        end
        else if (FlushD) begin
            // If flush signal is high, clear the outputs
            PCD      <= 32'b0;
            PCPlus4D <= 32'b0;
            instrD   <= 32'b0;
        end
        else if (!StallD) begin
            // If not stalled, update outputs with inputs
            PCD      <= PCF;
            PCPlus4D <= PCPlus4F;
            instrD   <= instrF;
        end
        // If StallD is high, hold current values (implicitly handled by not updating)
    end

endmodule