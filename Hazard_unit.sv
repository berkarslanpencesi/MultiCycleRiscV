`timescale 1ns / 1ps

module Hazard_Unit (
    input  logic [4:0] Rs1E, Rs2E,
    input  logic [4:0] RdM, RdW,
    input  logic       RegWriteM, RegWriteW, 
    input  logic       BranchE,
    output logic [1:0] ForwardAE, ForwardBE,
    
    input  logic [4:0] Rs1D, Rs2D,
    input  logic [4:0] RdE,
    input  logic [1:0] ResultSrcE,
    output logic       StallF, StallD, FlushE,
    input  logic       mux1,
    output logic       FlushD
);

    logic lwStall;

    // ForwardAE logic
    always_comb begin
        if ((Rs1E == RdM) && (RegWriteM || BranchE) && (Rs1E != 5'b00000)) begin
            ForwardAE = 2'b10;
        end
        else if ((Rs1E == RdW) && (RegWriteW || BranchE) && (Rs1E != 5'b00000)) begin
            ForwardAE = 2'b01;
        end
        else begin
            ForwardAE = 2'b00;
        end
    end

    // ForwardBE logic
    always_comb begin
        if ((Rs2E == RdM) && (RegWriteM || BranchE) && (Rs2E != 5'b00000)) begin
            ForwardBE = 2'b10;
        end
        else if ((Rs2E == RdW) && (RegWriteW || BranchE) && (Rs2E != 5'b00000)) begin
            ForwardBE = 2'b01;
        end
        else begin
            ForwardBE = 2'b00;
        end
    end

    // Load-use hazard detection
    assign lwStall = ((Rs1D == RdE) || (Rs2D == RdE)) && (ResultSrcE == 2'b01);
    assign StallF  = lwStall;
    assign StallD  = lwStall;
    assign FlushE  = lwStall || mux1;
    assign FlushD  = mux1;

endmodule
