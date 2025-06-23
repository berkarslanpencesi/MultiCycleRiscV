`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.08.2024 13:00:52
// Design Name: 
// Module Name: mux
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

module mux #(
    parameter Size = 32
) (
    input  logic [Size-1:0] in0,     // First input
    input  logic [Size-1:0] in1,     // Second input
    input  logic            sel,      // Select signal
    output logic [Size-1:0] out       // Output
);

    assign out = sel ? in1 : in0;     // Mux operation: select in1 if sel is 1, else in0

endmodule