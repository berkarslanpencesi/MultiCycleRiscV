
`timescale 1ns / 1ps
module Mem #(
    parameter MEM_SIZE = 8192,           // Memory size in words
    parameter DMemInitFile = "dmem.mem", // Initialization file
    parameter BASE_ADDR = 32'h8000_0000 // Base address
)(
    input [31:0] addr_i,// memory adddres input for reading
    input clk, rst,
    input [2:0] MemWrite,
    input [2:0] MemRead,
    input [31:0] Address,
    input [31:0] Write_Data,
    output reg [31:0] ReadDataM   ,
    output reg [31:0] data_o  
//    input integer LogFile    
);
    reg [31:0] mem [0:8191];                                      
    wire write_enable;
    integer i;
    wire [31:0] word_address = Address - BASE_ADDR;  // Consistent base address
    initial begin
            $readmemh(DMemInitFile, mem);  // Corrected initialization file parameter
        end 
    assign write_enable = |MemWrite;           
    // Write operations
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the entire memory to 0
            for (i = 0; i < MEM_SIZE; i = i + 1) begin
                mem[i] <= 32'b0;
            end
        end 
        else if (write_enable) begin
            case(MemWrite)
                3'b001: begin // SB (Store Byte)
                    mem[word_address[31:2]][7:0] <= Write_Data[7:0];
//                        $fwrite(LogFile, "mem 0x%h 0x%h", word_address[31:2], Write_Data[7:0]); // log the register file writes               
                    
                end
                3'b010: begin // SH (Store Halfword)
                    mem[word_address[31:2]][15:0] <= Write_Data[15:0];
//                    $fwrite(LogFile, "mem 0x%h 0x%h", word_address[31:2], Write_Data[15:0]); // log the register file writes                   
                end
                3'b100: begin // SW (Store Word)
                    mem[word_address[31:2]] <= Write_Data;
//                    $fwrite(LogFile, "mem 0x%h 0x%h", word_address[31:2], Write_Data); // log the register file writes                 
                end
                default: ; // Do nothing
            endcase
        end
    end

    // Read operations
    always @(*) begin
        ReadDataM = 32'b0; // Default value
        if (|MemRead) begin
            case(MemRead)
                3'b001: begin // LBU (Load Byte Unsigned)
                    ReadDataM = {24'b0, mem[word_address[31:2]][7:0]};
                end
                3'b010: begin // LHU (Load Halfword Unsigned)
                    ReadDataM = {16'b0, mem[word_address[31:2]][15:0]};
                end
                3'b011: begin // LB (Load Byte)
                    ReadDataM = {{24{mem[word_address[31:2]][7]}}, mem[word_address[31:2]][7:0]};
                end
                3'b100: begin // LH (Load Halfword)
                    ReadDataM = {{16{mem[word_address[31:2]][15]}}, mem[word_address[31:2]][15:0]};
                end
                3'b101: begin // LW (Load Word)
                    ReadDataM = mem[word_address[31:2]];
                end
                default: ReadDataM = 32'b0;
            endcase
        end
    end
    always @(*) begin
            data_o = mem[addr_i[31:2]];  // Simple word read
        end
endmodule
