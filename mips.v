module MIPS;
  reg clk;
  initial begin
    clk <= 0;
    #350
    forever #350 clk <= ~clk;
  end

  wire [31:0] pc, next_pc, IF_pc_plus_4, ID_pc_plus_4;
  wire [31:0] IF_instruction, ID_instruction;
  wire [5:0] opcode, ID_funct, EX_funct;
  wire [4:0] ID_rs, ID_rt, ID_rd, ID_shamt;
  wire [4:0] EX_rs, EX_rt, EX_rd, EX_shamt;
  wire [15:0] ID_shift;
  wire [15:0] EX_shift;
  wire [25:0] jump_address;
  wire [31:0] ID_reg_file_write_data, ID_reg_file_read_data1, ID_reg_file_read_data2;
  wire [31:0] EX_reg_file_read_data1, EX_reg_file_read_data2;
  wire [31:0] MEM_reg_file_read_data2;
  wire [31:0] WB_reg_file_write_data;
  wire [3:0] EX_alu_control;
  wire [31:0] EX_alu_input_A, EX_alu_input_B;
  wire [31:0] EX_alu_output, MEM_alu_output, WB_alu_output;
  wire EX_alu_zero;
  wire [31:0] ID_sign_extended_shift;
  wire [31:0] MEM_data_mem_output, WB_data_mem_output;
  wire [31:0] branch_offset;
  wire [31:0] taken_branch_pc;
  wire [31:0] branch_mux_pc;
  wire take_branch;
  wire RegWrite_unless_jr;
  wire not_jr;
  wire [31:0] jump_pc;
  wire [31:0] jump_mux_pc;

  wire ID_Branch, ID_MemRead, ID_MemWrite, ID_ALUSrc, ID_RegWrite, ID_Jump, ID_SignExtend;
  wire [1:0] ID_ALUOp, ID_RegDst, ID_MemtoReg;
  wire EX_MemRead, EX_MemWrite, EX_ALUSrc, EX_RegWrite;
  wire [1:0] EX_ALUOp, EX_RegDst, EX_MemtoReg;
  wire MEM_MemRead, MEM_MemWrite, MEM_RegWrite;
  wire [1:0] MEM_MemtoReg;
  wire WB_RegWrite;
  wire [1:0] WB_MemtoReg;

  wire [4:0] ID_control_EX; assign ID_control_EX = {ID_ALUOp, ID_ALUSrc, ID_RegDst};
  wire [1:0] ID_control_MEM; assign ID_control_MEM = {ID_MemRead, ID_MemWrite};
  wire [2:0] ID_control_WB; assign ID_control_WB = {ID_MemtoReg, ID_RegWrite};
  wire [4:0] EX_control_EX; assign EX_control_EX = {EX_ALUOp, EX_ALUSrc, EX_RegDst};
  wire [1:0] EX_control_MEM; assign EX_control_MEM = {EX_MemRead, EX_MemWrite};
  wire [2:0] EX_control_WB; assign EX_control_WB = {EX_MemtoReg, EX_RegWrite};
  wire [1:0] MEM_control_MEM; assign MEM_control_MEM = {MEM_MemRead, MEM_MemWrite};
  wire [2:0] MEM_control_WB; assign MEM_control_WB = {MEM_MemtoReg, MEM_RegWrite};
  wire [2:0] WB_control_WB; assign WB_control_WB = {WB_MemtoReg, WB_RegWrite};
  
  wire Comparator_result;
  wire [4:0] EX_Write_Reg, MEM_rt;
  wire control_flush, pc_freeze, IF_ID_freeze, IF_ID_flush;
  
  wire [4:0] EX_reg_file_write_reg, MEM_reg_file_write_reg, WB_reg_file_write_reg;
  /////////////////////////////////////////////////////////
  assign jump_pc = {IF_pc_plus_4[31], IF_pc_plus_4[30], IF_pc_plus_4[29], IF_pc_plus_4[28], jump_address, 2'b00};
  and g1(take_branch, ID_Branch, EX_alu_zero);
  not g2(not_jr, jr);
  and g3(RegWrite_unless_jr, WB_RegWrite, not_jr);

  /////////////////////////////////////////////////
  // IF
  PC pc_module(in, clk, pc_freeze, );
  Adder adder_module(pc, 4, IF_pc_plus_4);
  InstructionMemory instruction_memory_module(pc, IF_instruction);
  //////////////////////////////////////////////////
  Register_IF_ID if_id_register(clk, IF_ID_flush, IF_ID_freeze, IF_pc_plus_4, ID_pc_plus_4, IF_instruction, ID_instruction);
  //////////////////////////////////////////////////
  // ID
  Decoder decoder_module(ID_instruction, opcode, ID_rs, ID_rt, ID_rd, shamt, funct, ID_shift, jump_address);
  Control control_module(opcode, ID_RegDst, ID_Branch, ID_MemRead, ID_MemtoReg, ID_ALUOp, ID_MemWrite, ID_ALUSrc, ID_RegWrite, ID_Jump, ID_SignExtend);
  HazardDetectionUnit mHazardDetectionUnit(Comparator_result, ID_Branch , EX_MemRead, EX_rt, EX_RegWrite, EX_Write_Reg, MEM_MemRead, MEM_rt, ID_rs, ID_rt, control_flush, pc_freeze, IF_ID_freeze, take_branch, IF_ID_flush);
  ShiftLeft2 shift_left_2_module(ID_sign_extended_shift, branch_offset);
  Adder branch_adder_module(ID_pc_plus_4, branch_offset, taken_branch_pc);
  Mux2_32b branch_mux(branch_mux_pc, take_branch, ID_pc_plus_4, taken_branch_pc);
  RegisterFile register_file_module(ID_rs, ID_rt, WB_reg_file_write_reg, WB_reg_file_write_data, RegWrite_unless_jr, clk, ID_reg_file_read_data1, ID_reg_file_read_data2);
  //////////////////////////////////////////////////
  Register_ID_EX mRegister_ID_EX(clk, ID_control_EX, EX_control_EX, ID_control_MEM, EX_control_MEM, ID_control_WB, EX_control_WB, ID_reg_file_read_data1, EX_reg_file_read_data1, ID_reg_file_read_data2, EX_reg_file_read_data2, ID_rs, EX_rs, ID_rt, EX_rt, ID_rd, EX_rd, ID_sign_extended_shift, EX_sign_extended_shift, ID_shamt, EX_shamt, ID_funct, EX_funct);
  //////////////////////////////////////////////////
  // EX
  Mux4_5b reg_dst_mux(EX_reg_file_write_reg, EX_RegDst, EX_rt, EX_rd, 5'd32, 5'bx);
  Mux2_32b alu_src_mux(EX_alu_input_B, EX_ALUSrc, EX_reg_file_read_data2, EX_sign_extended_shift);
// TODO sign_extended shift
  ALUControl EX_alu_control_module(EX_alu_control, jr, EX_ALUOp, EX_funct);
  assign EX_alu_input_A = EX_reg_file_read_data1;
  ALU alu_module(EX_alu_input_A, EX_alu_input_B, EX_alu_control, EX_shamt, EX_alu_output, EX_alu_zero);
//TODO shamt funct from ID/EX Register
  
  //////////////////////////////////////////////////
  Register_EX_MEM mRegister_EX_MEM(clk, EX_control_MEM, MEM_control_MEM, EX_control_WB, MEM_control_WB, EX_alu_output, MEM_alu_output, EX_reg_file_read_data2, MEM_reg_file_read_data2, EX_reg_file_write_reg, MEM_reg_file_write_reg);
  //////////////////////////////////////////////////
  // MEM
  Sign_extend sign_extend_module(ID_shift, ID_SignExtend, ID_sign_extended_shift);
  DataMemory data_memory_module(MEM_alu_output, MEM_reg_file_read_data2, MEM_MemRead, MEM_MemWrite, clk, MEM_data_mem_output);
  
  Mux2_32b jump_mux(jump_mux_pc, Jump, branch_mux_pc, jump_pc);
  Mux2_32b jr_mux(next_pc, jr, jump_mux_pc, ID_reg_file_read_data1);
  //////////////////////////////////////////////////
  Register_MEM_WB mRegister_MEM_WB(clk, MEM_control_WB, RegWrite_unless_jr, MEM_data_mem_output, WB_data_mem_output, MEM_alu_output, WB_alu_output, MEM_reg_file_write_reg, WB_reg_file_write_reg);
  /////////////////////////////////////////////////
  // WB
  Mux4_32b mem_to_reg_mux(ID_reg_file_write_data, MEM_MemtoReg, MEM_alu_output, MEM_data_mem_output, pc_plus_4, 32'bx);
endmodule
