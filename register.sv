module register (
    input logic clk, rst,
    input logic [4:0] rd_addr0, wr_addr0, rd_addr1,
    input logic [31:0] wr_din0,
    input logic we0,
    output logic [31:0] rd_dout0, rd_dout1
//    input integer LogFile
);

    logic [31:0] mem [0:31];
    
    
    always_ff @(negedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) mem[i] <= 32'b0;
        end else if (we0 && wr_addr0 != 5'h0) begin
            mem[wr_addr0] <= wr_din0;   
        end
    end


       assign rd_dout0 = (rd_addr0 == 5'h0) ? 32'b0 : mem[rd_addr0];
       assign rd_dout1 = (rd_addr1 == 5'h0) ? 32'b0 : mem[rd_addr1];

endmodule
