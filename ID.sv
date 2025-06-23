`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2024 17:51:48
// Design Name: 
// Module Name: ID
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

module ID (
    input  logic [31:0] instrD,           // Instruction from Decode stage
    input  logic [31:0] ResultW,          // Result from Write-Back stage
    input  logic        RegWriteW,        // Register write enable from Write-Back stage
    input  logic        clk,              // Clock signal
    input  logic        rst,              // Reset signal
    input  logic [4:0]  RdW,              // Destination register address from Write-Back stage

    output logic [31:0] RD1D,             // Source register 1 data
    output logic [31:0] RD2D,             // Source register 2 data
    output logic [31:0] ExtimmD,          // Extended immediate value
    output logic        RegWriteD,        // Register write enable for Decode stage
    output logic [1:0]  ResultSrcD,       // Result source select (mux5)
    output logic [2:0]  MemWriteD,        // Memory write control
    output logic [2:0]  MemReadD,         // Memory read control
    output logic        JumpD,            // Jump control
    output logic        BranchD,          // Branch control
    output logic [4:0]  AluControlD,      // ALU control
    output logic        mux2D,            // Mux control for ALU source
    output logic        mux3D,            // Mux control
    output logic        mux4D,            // Mux control
    output logic [4:0]  RS1D,             // Source register 1 address
    output logic [4:0]  RS2D,             // Source register 2 address
    output logic [4:0]  RdD               // Destination register address
);
    
    logic [4:0] AA, BA;                   // Register address signals

    // Assign register addresses from instruction fields
    assign AA = instrD[19:15];           // rs1 (source register 1)
    assign BA = instrD[24:20];           // rs2 (source register 2)
    assign RS1D = instrD[19:15];         // Source register 1 address
    assign RS2D = instrD[24:20];         // Source register 2 address
    assign RdD = instrD[11:7];           // Destination register address

    // Register File
    register REG_inst (
        .clk(clk),
        .rst(rst),
        .rd_addr0(AA),
        .wr_addr0(RdW),
        .rd_addr1(BA), 
        .wr_din0(ResultW),
        .we0(RegWriteW),
        .rd_dout0(RD1D),
        .rd_dout1(RD2D)
    );
    
    // Immediate Decoder
    imm_decoder imminstr (
        .instr(instrD),
        .ExtimmD(ExtimmD)
    );
    
    // Control Unit
    Control Controlinstr (
        .instr(instrD),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .MemReadD(MemReadD),    
        .JumpD(JumpD),
        .BranchD(BranchD),
        .AluControl(AluControlD),
        .mux2D(mux2D),
        .mux3D(mux3D),
        .mux4D(mux4D)
    );

endmodule