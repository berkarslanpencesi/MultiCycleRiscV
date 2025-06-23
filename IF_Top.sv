`timescale 1ns / 1ps

module IF_top (
    input  logic        clk,             // Clock signal
    input  logic        rst,             // Reset signal
    input  logic        mux1,            // Mux select for PC source
    input  logic [31:0] PctargetE,       // Target PC from Execute stage (for branches/jumps)
    input  logic        StallF,          // Stall signal for Fetch stage
    output logic [31:0] PCF,             // Program Counter for Fetch stage
    output logic [31:0] PCPlus4F,        // PC + 4 for Fetch stage
    
    
    output logic [31:0] instrF           // Fetched instruction
);
    wire [31:0] PC;
    assign PC= mux1==1'b1 ? PctargetE :PCPlus4F ;
    pc PC_instr (       
        .clk(clk),
        .rst(rst),
        .oldpc(PC),       
        .StallF(StallF),
        .newpc(PCF),
        .pcplus4(PCPlus4F)
    );     
     
    instr_mem instrdesign ( 
        .newpc(PCF),
        .instrF(instrF)
    );              

endmodule   