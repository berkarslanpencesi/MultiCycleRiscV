module pc (
    input  logic        clk,          // Clock signal
    input  logic        rst,          // Reset signal
    input  logic [31:0] oldpc,        // Input program counter value
    input  logic        StallF,       // Stall signal for Fetch stage
    output logic [31:0] newpc,        // Output program counter
    output logic [31:0] pcplus4     // Output program counter + 4
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            newpc   <= 32'h8000_0000; // Reset PC to initial address
            pcplus4 <= 32'h8000_0004; // Reset PC+4 to initial address + 4
        end else if (!StallF) begin
            newpc   <= oldpc;         // Update PC with input value
            pcplus4 <= oldpc + 32'd4; // Update PC+4
        end
        // When StallF is high, hold current values (implicitly handled by no update)
    end

endmodule