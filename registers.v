module Register_IF_ID(clk, IF_Flush, freeze, pc_plus_4, pc_plus_4_out, instruction, instruction_out);
  input clk, IF_Flush, freeze;
  input [31:0] instruction, pc_plus_4;
  output reg [31:0] instruction_out, pc_plus_4_out;

  always @(posedge clk) begin
    if (IF_Flush)
      instruction_out = 32'd0;
    else if(!freeze) begin
      instruction_out = instruction;
      pc_plus_4_out = pc_plus_4;
    end
  end
endmodule

module Register_ID_EX(clk, control_EX, control_EX_out, control_MEM, control_MEM_out, control_WB, control_WB_out, reg_file_read_data1, reg_file_read_data1_out, reg_file_read_data2, reg_file_read_data2_out, rs, rs_out, rt, rt_out, rd, rd_out, sign_extended_shift, sign_extended_shift_out, shamt, shamt_out, funct, funct_out);
  input clk;
  input [4:0] control_EX; output reg [4:0] control_EX_out;
  input [1:0] control_MEM; output reg [1:0] control_MEM_out;
  input [2:0] control_WB; output reg [2:0] control_WB_out;

  input [31:0] reg_file_read_data1, reg_file_read_data2; output reg [31:0] reg_file_read_data1_out, reg_file_read_data2_out;
  input [31:0] sign_extended_shift; output reg [31:0] sign_extended_shift_out;
  input [4:0] rs, rt, rd, shamt; output reg [4:0] rs_out, rt_out, rd_out, shamt_out;
  input [5:0] funct; output reg [5:0] funct_out;

  always @(posedge clk) begin
    control_EX_out = control_EX;
    control_MEM_out = control_MEM;
    control_WB_out = control_WB;

    reg_file_read_data1_out = reg_file_read_data1;
    reg_file_read_data2_out = reg_file_read_data2;

    rs_out = rs;
    rt_out = rt;
    rd_out = rd;
    shamt_out = shamt;
    funct_out = funct;

    sign_extended_shift_out = sign_extended_shift;
  end
endmodule

module Register_EX_MEM(clk, control_MEM, control_MEM_out, control_WB, control_WB_out, alu_output, alu_output_out, reg_file_read_data2, reg_file_read_data2_out, reg_file_write_reg, reg_file_write_reg_out);
  input clk;
  input [1:0] control_MEM; output reg [1:0] control_MEM_out;
  input [2:0] control_WB; output reg [2:0] control_WB_out;

  input [31:0] alu_output, reg_file_read_data2; output reg [31:0] alu_output_out, reg_file_read_data2_out;
  input [4:0] reg_file_write_reg; output reg [4:0] reg_file_write_reg_out;

  always @(posedge clk) begin
    control_MEM_out = control_MEM;
    control_WB_out = control_WB;
    alu_output_out = alu_output;
    reg_file_read_data2_out = reg_file_read_data2;
    reg_file_write_reg_out = reg_file_write_reg;
  end
endmodule

module Register_MEM_WB(clk, control_WB, control_WB_out, data_mem_output, data_mem_output_out, alu_output, alu_output_out, reg_file_write_reg, reg_file_write_reg_out);
  input clk;
  input [2:0] control_WB; output reg [2:0] control_WB_out;

  input [31:0] data_mem_output, alu_output; output reg [31:0] data_mem_output_out, alu_output_out;
  input [4:0] reg_file_write_reg; output reg [4:0] reg_file_write_reg_out;

  always @(posedge clk) begin
    control_WB_out = control_WB;

    data_mem_output_out = data_mem_output;
    alu_output_out = alu_output;

    reg_file_write_reg_out = reg_file_write_reg;
  end
endmodule
