`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2024 22:19:43
// Design Name: 
// Module Name: ID_X
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

module ID_X (
    input  logic        clk, rst,
    
    // Input signals from ID stage
    input  logic        RegWriteD,        // 1-bit control signal for register write
    input  logic [1:0]  ResultSrcD,       // Control signal (2 bits to select source)
    input  logic [2:0]  MemWriteD,        // 3-bit control signal for memory write
    input  logic [2:0]  MemReadD,         // 3-bit control signal for memory read
    input  logic        JumpD,            // 1-bit control signal for jump
    input  logic        BranchD,          // 1-bit control signal for branch
    input  logic [4:0]  AluControlD,      // 4-bit control signal for ALU operation
    input  logic        mux2D,            // 1-bit control signal for ALU source select
    input  logic        mux3D,            // 1-bit control signal
    input  logic        mux4D,            // 1-bit control signal
    input  logic [31:0] RD1D,             // 32-bit data from source register 1
    input  logic [31:0] RD2D,             // 32-bit data from source register 2
    input  logic [31:0] PCD,              // 32-bit program counter data
    input  logic [4:0]  RS1D,             // 5-bit source register 1 address
    input  logic [4:0]  RS2D,             // 5-bit source register 2 address
    input  logic [4:0]  RdD,              // 5-bit destination register address
    input  logic [31:0] ExTimmD,          // 32-bit immediate value
    input  logic [31:0] PcPlus4D,         // 32-bit PC+4 value
    input  logic        FlushE,           // 1-bit control signal to flush pipeline
    
    // Output signals to EX stage
    output logic        RegWriteE,        // 1-bit control signal for register write enable
    output logic [1:0]  ResultSrcE,       // Control signal (2 bits to select source)
    output logic [2:0]  MemWriteE,        // 3-bit control signal for memory write
    output logic [2:0]  MemReadE,         // 3-bit control signal for memory read
    output logic        JumpE,            // 1-bit control signal for jump
    output logic        BranchE,          // 1-bit control signal for branch
    output logic [4:0]  AluControlE,      // 4-bit control signal for ALU operation
    output logic        mux2E,            // 1-bit control signal for ALU source select
    output logic        mux3E,            // 1-bit control signal
    output logic        mux4E,            // 1-bit control signal
    output logic [31:0] RD1E,             // 32-bit data from source register 1
    output logic [31:0] RD2E,             // 32-bit data from source register 2
    output logic [31:0] PCE,              // 32-bit program counter data
    output logic [4:0]  RS1E,             // 5-bit source register 1 address
    output logic [4:0]  RS2E,             // 5-bit source register 2 address
    output logic [4:0]  RdE,              // 5-bit destination register address
    output logic [31:0] ExTimmE,          // 32-bit immediate value
    output logic [31:0] PcPlus4E          // 32-bit PC+4 value
);

// Sequential logic to update output signals on the rising edge of the clock
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all outputs to their default values
        RegWriteE   <= 1'b0;
        ResultSrcE  <= 2'b00;
        MemWriteE   <= 3'b000;
        MemReadE    <= 3'b000;
        JumpE       <= 1'b0;
        BranchE     <= 1'b0;
        AluControlE <= 5'b00000;
        mux2E       <= 1'b0;
        mux3E       <= 1'b0;
        mux4E       <= 1'b0;
        RD1E        <= 32'b0;
        RD2E        <= 32'b0;
        PCE         <= 32'b0;
        RS1E        <= 5'b0;
        RS2E        <= 5'b0;
        RdE         <= 5'b0;
        ExTimmE     <= 32'b0;
        PcPlus4E    <= 32'b0;
    end 
    else if (FlushE) begin
        // Flush all outputs to their default values if FlushE is asserted
        RegWriteE   <= 1'b0;
        ResultSrcE  <= 2'b00;
        MemWriteE   <= 3'b000;
        MemReadE    <= 3'b000;
        JumpE       <= 1'b0;
        BranchE     <= 1'b0;
        AluControlE <= 5'b00000;
        mux2E       <= 1'b0;
        mux3E       <= 1'b0;
        mux4E       <= 1'b0;
        RD1E        <= 32'b0;
        RD2E        <= 32'b0;
        PCE         <= 32'b0;
        RS1E        <= 5'b0;
        RS2E        <= 5'b0;
        RdE         <= 5'b0;
        ExTimmE     <= 32'b0;
        PcPlus4E    <= 32'b0;
    end 
    else begin
        // Normal operation: assign the inputs to the outputs on the clock edge
        RegWriteE   <= RegWriteD;
        ResultSrcE  <= ResultSrcD;
        MemWriteE   <= MemWriteD;
        MemReadE    <= MemReadD;
        JumpE       <= JumpD;
        BranchE     <= BranchD;
        AluControlE <= AluControlD;
        mux2E       <= mux2D;
        mux3E       <= mux3D;
        mux4E       <= mux4D;
        RD1E        <= RD1D;
        RD2E        <= RD2D;
        PCE         <= PCD;
        RS1E        <= RS1D;
        RS2E        <= RS2D;
        RdE         <= RdD;
        ExTimmE     <= ExTimmD;
        PcPlus4E    <= PcPlus4D;      
    end
end

endmodule