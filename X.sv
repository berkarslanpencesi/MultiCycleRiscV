`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2024 22:49:09
// Design Name: 
// Module Name: X
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

module X #(
    parameter Size = 32
) (
    input  logic        JumpE,            // Jump control signal
    input  logic        BranchE,          // Branch control signal
    input  logic [4:0]  AluControlE,      // ALU control signal
    input  logic        mux2E,            // Mux2 select signal
    input  logic        mux3E,            // Mux3 select signal
    input  logic        mux4E,            // Mux4 select signal
    input  logic [31:0] RD1E,             // Source register 1 data
    input  logic [31:0] RD2E,             // Source register 2 data
    input  logic [31:0] PCE,              // Program counter
    input  logic [4:0]  RS1E,             // Source register 1 address
    input  logic [4:0]  RS2E,             // Source register 2 address
    input  logic [31:0] ExTimmE,          // Extended immediate
    input  logic [1:0]  ForwardAE,        // Forwarding control for ALU input A
    input  logic [1:0]  ForwardBE,        // Forwarding control for ALU input B
    input  logic [31:0] ResultW,          // Result from Write-Back stage
    input  logic [31:0] ALUResultM,       // ALU result from Memory stage
    
    output logic        mux1E,            // Mux1 select for PC source
    output logic [31:0] WriteDataE,       // Data to write to memory
    output logic [31:0] alu_out,          // ALU output
    output logic [31:0] PCTargetE         // Target PC for branches/jumps
);

    logic [31:0] rs1, rs2;                // Forwarded ALU inputs
    logic [31:0] SrcAE, SrcBE;            // ALU source inputs after muxes
    logic [31:0] Pcaddrin;                // PC address input for target calculation
    logic        BranchControl;           // Branch condition result

    // Forwarding logic for ALU input A
    always_comb begin
        case (ForwardAE)
            2'b00: rs1 = RD1E;
            2'b01: rs1 = ResultW;
            2'b10: rs1 = ALUResultM;
            default: rs1 = RD1E;         // Default case for safety
        endcase
    end
    
    // Forwarding logic for ALU input B
    always_comb begin
        case (ForwardBE)
            2'b00: rs2 = RD2E;
            2'b01: rs2 = ResultW;
            2'b10: rs2 = ALUResultM;
            default: rs2 = RD2E;         // Default case for safety
        endcase
    end        

    // Write data to memory
    assign WriteDataE = rs2;
    
    // Mux2: Select between rs1 and PCE for ALU input A
    mux #(.Size(Size)) Mux2_inst (
        .in0(rs1),
        .in1(PCE),
        .sel(mux2E),
        .out(SrcAE)
    );        

    // Mux3: Select between rs2 and ExTimmE for ALU input B
    mux #(.Size(Size)) Mux3_inst (
        .in0(rs2),
        .in1(ExTimmE),
        .sel(mux3E),
        .out(SrcBE)
    );        

    // Mux4: Select between ExTimmE and rs1 for PC address input
    mux #(.Size(Size)) Mux4_inst (
        .in0(ExTimmE),
        .in1(rs1),
        .sel(mux4E),
        .out(Pcaddrin)
    );           

    // PC target calculation using DSP-friendly addition
    assign PCTargetE = PCE + Pcaddrin;   // Replace CLA with simple addition for DSP block

    // ALU operation
    alu ALU2_inst (
        .src1(SrcAE),    
        .src2(SrcBE),
        .func(AluControlE),
        .alu_out(alu_out)
    );
    
    // Branch control logic
    assign BranchControl = BranchE & alu_out[0];   //alu out not mý bu halimi       
    assign mux1E = JumpE | BranchControl;

endmodule