module core_model
  import riscv_pkg::*;
#(
    parameter DMemInitFile  = "dmem.mem",       // data memory initialization file
    parameter IMemInitFile  = "imem.mem"        // instruction memory initialization file
) (
    input  logic             clk_i,       // system clock
    input  logic             rstn_i,      // system reset (active-low)
    input  logic  [XLEN-1:0] addr_i,      // memory address input for reading
    output logic  [XLEN-1:0] data_o,      // memory data output for reading
    output logic             update_o,    // retire signal
    output logic  [XLEN-1:0] pc_o,        // retired program counter
    output logic  [XLEN-1:0] instr_o,     // retired instruction
    output logic  [     4:0] reg_addr_o,  // retired register address
    output logic  [XLEN-1:0] reg_data_o,  // retired register data
    output logic  [XLEN-1:0] mem_addr_o,  // retired memory address
    output logic  [XLEN-1:0] mem_data_o,  // retired memory data
    output logic             mem_wrt_o    // retired memory write enable signal
);
  // Internal signals for module interconnections
  logic [31:0] PCF, PCPlus4F, instrF;              // IF stage outputs
  logic [31:0] PCD, PCPlus4D, instrD;              // IF/ID stage outputs
  logic [31:0] RD1D, RD2D, ExtimmD;                // ID stage outputs
  logic        RegWriteD, JumpD, BranchD, mux2D, mux3D, mux4D;
  logic [1:0]  ResultSrcD;
  logic [2:0]  MemWriteD, MemReadD;
  logic [4:0]  AluControlD, RS1D, RS2D, RdD;
  logic [31:0] RD1E, RD2E, PCE, ExTimmE, PcPlus4E; // ID/X stage outputs
  logic        RegWriteE, JumpE, BranchE, mux2E, mux3E, mux4E;
  logic [1:0]  ResultSrcE;
  logic [2:0]  MemWriteE, MemReadE;
  logic [4:0]  AluControlE, RS1E, RS2E, RdE;
  logic [31:0] WriteDataE, alu_out, PCTargetE;     // X stage outputs
  logic        mux1E;
  logic [31:0] alu_outM, WriteDataM, PcPlus4M;     // X/Mem stage outputs
  logic        RegWriteM;
  logic [1:0]  ResultSrcM;
  logic [2:0]  MemWriteM, MemReadM;
  logic [4:0]  RdM;
  logic [31:0] ReadDataM;                          // Mem stage outputs
  logic [31:0] AluResultW, ReadDataW, PCPlus4W;    // MEM/WB stage outputs
  logic        RegWriteW;
  logic [1:0]  ResultSrcW;
  logic [4:0]  RdW;
  logic [31:0] ResultW;                            // WB stage output
  logic [1:0]  ForwardAE, ForwardBE;               // Hazard Unit outputs
  logic        StallF, StallD, FlushD, FlushE;
  logic        rst;                                // Active-high reset

  // Reset signal conversion (active-low to active-high)
  assign rst = ~rstn_i;

  // IF_top instantiation (Fetch stage)
  IF_top u_if_top ( //burdan çift çýkýþ çekmem lazým
    .clk(clk_i),
    .rst(rst),
    .mux1(mux1E),           // From X stage
    .PctargetE(PCTargetE),  // From X stage
    .StallF(StallF),        // From Hazard Unit
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .instrF(instrF)
  );

  // if_id instantiation (Fetch/Decode pipeline register)
  if_id u_if_id (
    .clk(clk_i),
    .rst(rst),
    .StallD(StallD),        // From Hazard Unit
    .FlushD(FlushD),        // From Hazard Unit
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .instrF(instrF),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),
    .instrD(instrD)
  );

  // ID instantiation (Decode stage)
  ID u_id (
    .instrD(instrD),
    .ResultW(ResultW),
    .RegWriteW(RegWriteW),
    .clk(clk_i),
    .rst(rst),
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

  // ID_X instantiation (Decode/Execute pipeline register)
  ID_X u_id_x (//register giriþ çýkýþ çoðalcak
    .clk(clk_i),
    .rst(rst),
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
    .FlushE(FlushE),
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

  // X instantiation (Execute stage)
  X #(
    .Size(32)
  ) u_x (
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
    .ExTimmE(ExTimmE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .ResultW(ResultW),
    .ALUResultM(alu_outM),
    .mux1E(mux1E),
    .WriteDataE(WriteDataE),
    .alu_out(alu_out),
    .PCTargetE(PCTargetE)
  );

  // X_Mem instantiation (Execute/Memory pipeline register)
  X_Mem u_x_mem (
    .clk(clk_i),
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

  // Mem instantiation (Memory stage)
Mem #(
      .MEM_SIZE(8192),
      .DMemInitFile(DMemInitFile),
      .BASE_ADDR(32'h8000_0000)
  ) u_mem (
      .addr_i(addr_i),           // Connected to addr_i
      .clk(clk_i),
      .rst(rst),
      .MemWrite(MemWriteM),
      .MemRead(MemReadM),
      .Address(alu_outM),
      .Write_Data(WriteDataM),
      .ReadDataM(ReadDataM),
      .data_o(data_o)            // Connected to data_o
  );

  // MEM_WB instantiation (Memory/Write-Back pipeline register)
  MEM_WB u_mem_wb (
    .clk(clk_i),
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

  // WB instantiation (Write-Back stage)
  WB u_wb (
    .ResultSrcW(ResultSrcW),
    .AluResultW(AluResultW),
    .ReadDataW(ReadDataW),
    .RdW(RdW),
    .PCPlus4W(PCPlus4W),
    .ResultW(ResultW)
  );

  // Hazard_Unit instantiation
  Hazard_Unit u_hazard_unit (
    .Rs1E(RS1E),        // Truncate to 4 bits as per module definition
    .Rs2E(RS2E),
    .RdM(RdM),
    .RdW(RdW),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .BranchE(BranchE),
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

  // Output assignments for riscv_multicycle
  assign update_o    = 1'b1;          // Register write indicates instruction retirement
  assign pc_o        = PCF;                // Current PC from Fetch stage
  assign instr_o     = instrF;             // Instruction from Decode stage
  assign reg_addr_o  = RdW;                // Retired register address
  assign reg_data_o  = ResultW;            // Retired register data
  assign mem_addr_o  = alu_outM;           // Memory address from Memory stage
  assign mem_data_o  = WriteDataM;         // Memory data from Memory stage
  assign mem_wrt_o   = |MemWriteM;         // Memory write enable (non-zero MemWriteM indicates write)

endmodule