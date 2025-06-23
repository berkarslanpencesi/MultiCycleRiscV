`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2024 13:50:38
// Design Name: 
// Module Name: Top_pipeline
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

module Top_pipeline (
    input  logic        clk,              // Clock signal
    input  logic        rst,              // Reset signal
    output logic [31:0] alu_outmcheck,    // ALU output from MEM stage for checking
    output logic [31:0] ResultWcheck,     // Result from WB stage for checking
    output logic [31:0] ReadDataWcheck    // Read data from WB stage for checking
);
    // Flush and Stall signals
    logic        FlushD;                  // Flush signal for Decode stage
    logic        StallD, StallF;          // Stall signals for Decode and Fetch stages
    logic        FlushE;                  // Flush signal for Execute stage
    logic [1:0]  ForwardAE, ForwardBE;    // Forwarding control signals for ALU inputs

    // Mux and control signals
    logic [1:0]  ResultSrcW;              // Result source select for WB stage

    // IF stage signals
    logic [31:0] PctargetE;               // Target PC from Execute stage
    logic [31:0] PCF;                     // Program Counter for Fetch stage
    logic [31:0] PCPlus4F;                // PC + 4 for Fetch stage
    logic [31:0] instrF;                  // Fetched instruction

    // ID stage signals
    logic [31:0] PCD;                     // Program Counter for Decode stage
    logic [31:0] PCPlus4D;                // PC + 4 for Decode stage
    logic [31:0] instrD;                  // Instruction for Decode stage
    logic        RegWriteW;               // Register write enable for WB stage
    logic [4:0]  RdW;                     // Destination register for WB stage
    logic [31:0] RD1D, RD2D;              // Source register data for Decode stage
    logic [31:0] ExtimmD;                 // Extended immediate for Decode stage
    logic        RegWriteD;               // Register write enable for Decode stage
    logic [1:0]  ResultSrcD;              // Result source select for Decode stage
    logic [2:0]  MemWriteD;               // Memory write control for Decode stage
    logic [2:0]  MemReadD;                // Memory read control for Decode stage
    logic        JumpD;                   // Jump control for Decode stage
    logic        BranchD;                 // Branch control for Decode stage
    logic [3:0]  AluControlD;             // ALU control for Decode stage
    logic        mux2D;                   // Mux control for Decode stage
    logic        mux3D;                   // Mux control for Decode stage
    logic        mux4D;                   // Mux control for Decode stage
    logic [4:0]  RS1D;                    // Source register 1 address for Decode stage
    logic [4:0]  RS2D;                    // Source register 2 address for Decode stage
    logic [4:0]  RdD;                     // Destination register address for Decode stage

    // EX stage signals
    logic        RegWriteE;               // Register write enable for Execute stage
    logic [1:0]  ResultSrcE;              // Result source select for Execute stage
    logic [2:0]  MemWriteE;               // Memory write control for Execute stage
    logic [2:0]  MemReadE;                // Memory read control for Execute stage
    logic        JumpE;                   // Jump control for Execute stage
    logic        BranchE;                 // Branch control for Execute stage
    logic [3:0]  AluControlE;             // ALU control for Execute stage
    logic        mux2E;                   // Mux control for Execute stage
    logic        mux3E;                   // Mux control for Execute stage
    logic        mux4E;                   // Mux control for Execute stage
    logic [31:0] RD1E;                    // Source register 1 data for Execute stage
    logic [31:0] RD2E;                    // Source register 2 data for Execute stage
    logic [31:0] PCE;                     // Program Counter for Execute stage
    logic [4:0]  RS1E;                    // Source register 1 address for Execute stage
    logic [4:0]  RS2E;                    // Source register 2 address for Execute stage
    logic [4:0]  RdE;                     // Destination register address for Execute stage
    logic [31:0] ExTimmE;                 // Extended immediate for Execute stage
    logic [31:0] PcPlus4E;                // PC + 4 for Execute stage
    logic        mux1E;                   // Mux control for PC source
    logic [31:0] WriteDataE;              // Data to write to memory
    logic [31:0] alu_out;                 // ALU output for Execute stage

    // MEM stage signals
    logic        RegWriteM;               // Register write enable for Memory stage
    logic [1:0]  ResultSrcM;              // Result source select for Memory stage
    logic [2:0]  MemWriteM;               // Memory write control for Memory stage
    logic [2:0]  MemReadM;                // Memory read control for Memory stage
    logic [4:0]  RdM;                     // Destination register address for Memory stage
    logic [31:0] PcPlus4M;                // PC + 4 for Memory stage
    logic [31:0] alu_outM;                // ALU output for Memory stage
    logic [31:0] WriteDataM;              // Data to write to memory
    logic [31:0] ReadDataM;               // Data read from memory

    // WB stage signals
    logic [31:0] AluResultW;              // ALU result for Write-Back stage
    logic [31:0] ResultW;                 // Final result for Write-Back stage
    logic [31:0] ReadDataW;               // Data read from memory for Write-Back stage
    logic [31:0] PCPlus4W;                // PC + 4 for Write-Back stage

    // Instruction Fetch Stage
    IF_top IFinstr (
        .clk(clk),
        .rst(rst),
        .StallF(StallF),
        .mux1(mux1E),
        .PctargetE(PctargetE),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .instrF(instrF)
    );

    // IF/ID Pipeline Register
    if_id if_idinstr (
        .clk(clk),
        .rst(rst),
        .StallD(StallD),
        .FlushD(FlushD),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .instrF(instrF),
        .PCD(PCD),          
        .PCPlus4D(PCPlus4D),
        .instrD(instrD)
    ); 
        
    // Instruction Decode Stage
    ID ID_instr (
        .clk(clk),
        .rst(rst),
        .instrD(instrD),
        .ResultW(ResultW),
        .RegWriteW(RegWriteW),
        .RdW(RdW),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .ExtimmD(ExtimmD),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .MemReadD(MemReadD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .AluControlD(AluControlD),
        .mux2D(mux2D),
        .mux3D(mux3D),
        .mux4D(mux4D),
        .RS1D(RS1D),
        .RS2D(RS2D),
        .RdD(RdD)
    );

    // ID/EX Pipeline Register
    ID_X ID_X_inst (
        .clk(clk), 
        .rst(rst), 
        .FlushE(FlushE),
        .RegWriteD(RegWriteD), 
        .ResultSrcD(ResultSrcD), 
        .MemWriteD(MemWriteD), 
        .MemReadD(MemReadD), 
        .JumpD(JumpD), 
        .BranchD(BranchD), 
        .AluControlD(AluControlD), 
        .mux2D(mux2D), 
        .mux3D(mux3D), 
        .mux4D(mux4D), 
        .RD1D(RD1D), 
        .RD2D(RD2D), 
        .PCD(PCD), 
        .RS1D(RS1D), 
        .RS2D(RS2D), 
        .RdD(RdD), 
        .ExTimmD(ExtimmD), 
        .PcPlus4D(PCPlus4D),
        .RegWriteE(RegWriteE), 
        .ResultSrcE(ResultSrcE), 
        .MemWriteE(MemWriteE), 
        .MemReadE(MemReadE), 
        .JumpE(JumpE), 
        .BranchE(BranchE), 
        .AluControlE(AluControlE), 
        .mux2E(mux2E), 
        .mux3E(mux3E), 
        .mux4E(mux4E), 
        .RD1E(RD1E), 
        .RD2E(RD2E), 
        .PCE(PCE), 
        .RS1E(RS1E), 
        .RS2E(RS2E), 
        .RdE(RdE), 
        .ExTimmE(ExTimmE), 
        .PcPlus4E(PcPlus4E)
    );

    // Execute Stage
    X #(.Size(32)) X_instr (
        .JumpE(JumpE), 
        .BranchE(BranchE), 
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ResultW(ResultW),
        .ALUResultM(alu_outM),
        .AluControlE(AluControlE), 
        .mux2E(mux2E), 
        .mux3E(mux3E), 
        .mux4E(mux4E), 
        .RD1E(RD1E), 
        .RD2E(RD2E), 
        .PCE(PCE), 
        .RS1E(RS1E), 
        .RS2E(RS2E), 
        .ExTimmE(ExTimmE), 
        .mux1E(mux1E), 
        .WriteDataE(WriteDataE), 
        .alu_out(alu_out), 
        .PCTargetE(PctargetE)
    );

    // EX/MEM Pipeline Register
    X_Mem X_Mem_inst (
        .clk(clk), 
        .rst(rst), 
        .RegWriteE(RegWriteE), 
        .ResultSrcE(ResultSrcE), 
        .MemWriteE(MemWriteE), 
        .MemReadE(MemReadE), 
        .RdE(RdE), 
        .PcPlus4E(PcPlus4E), 
        .alu_out(alu_out), 
        .WriteDataE(WriteDataE),
        .RegWriteM(RegWriteM), 
        .ResultSrcM(ResultSrcM), 
        .MemWriteM(MemWriteM), 
        .MemReadM(MemReadM), 
        .RdM(RdM), 
        .PcPlus4M(PcPlus4M), 
        .alu_outM(alu_outM), 
        .WriteDataM(WriteDataM)
    );

    // Memory Stage
    Mem Mem_inst (
        .clk(clk),
        .rst(rst), 
        .MemWrite(MemWriteM),
        .MemRead(MemReadM),
        .Adress(alu_outM),
        .Write_Data(WriteDataM),
        .ReadDataM(ReadDataM)
    );

    // MEM/WB Pipeline Register
    MEM_WB MEM_WB_inst (
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM), 
        .ResultSrcM(ResultSrcM), 
        .AluResultM(alu_outM), 
        .ReadDataM(ReadDataM), 
        .RdM(RdM), 
        .PCPlus4M(PcPlus4M),
        .RegWriteW(RegWriteW), 
        .ResultSrcW(ResultSrcW), 
        .AluResultW(AluResultW), 
        .ReadDataW(ReadDataW), 
        .RdW(RdW), 
        .PCPlus4W(PCPlus4W)
    );

    // Write-Back Stage
    WB WB_inst (
        .ResultSrcW(ResultSrcW), 
        .AluResultW(AluResultW), 
        .ReadDataW(ReadDataW), 
        .RdW(RdW), 
        .PCPlus4W(PCPlus4W), 
        .ResultW(ResultW)
    );

    // Hazard Unit
    Hazard_Unit hazard_unit_inst (
        .Rs1E(RS1E),
        .Rs2E(RS2E),
        .RdM(RdM),
        .BranchE(BranchE),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .Rs1D(RS1D),
        .Rs2D(RS2D),
        .RdE(RdE),
        .ResultSrcE(ResultSrcE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushE(FlushE),
        .mux1(mux1E),
        .FlushD(FlushD)
    );

    // Output assignments
    assign alu_outmcheck = alu_outM;
    assign ResultWcheck = ResultW;
    assign ReadDataWcheck = ReadDataW; // Corrected from instrD to ReadDataW

endmodule