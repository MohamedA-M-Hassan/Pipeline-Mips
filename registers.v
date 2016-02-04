module Register_IF_ID(clk, IF_Flush, freeze, pc_plus_4, pc_plus_4_out, instruction, instruction_out);
  input clk, IF_Flush, freeze;
  input [31:0] instruction, pc_plus_4;
  output reg [31:0] instruction_out, pc_plus_4_out;

  always @(posedge clk) begin
    if (IF_Flush)
      instruction = 32'd0;
    else if(!freeze) begin
      instruction_out = instruction;
      pc_plus_4_out = pc_plus_4;
    end
  end
endmodule

module Register_ID_EX(clk, control_EX, control_EX_out, control_MEM, control_MEM_out, control_WB, control_WB_out, reg_file_read_data1, reg_file_read_data1_out, reg_file_read_data2, reg_file_read_data2_out, shift, shift_out, rs, rs_out, rt, rt_out, rd, rd_out);
  input clk;
  input control_EX; output reg control_EX_out;
  input control_MEM; output reg control_MEM_out;
  input control_WB; output reg control_WB_out;

  input [31:0] reg_file_read_data1, reg_file_read_data2; output reg [31:0] reg_file_read_data1_out, reg_file_read_data2_out;
  input [15:0] shift; output reg [15:0] shift_out;
  input [4:0] rs, rt, rd; output reg [4:0] rs_out, rt_out, rd_out;

  always @(posedge clk) begin
    control_EX_out = control_EX;
    control_MEM_out = control_MEM;
    control_WB_out = control_WB;

    reg_file_read_data1_out = reg_file_read_data1;
    reg_file_read_data2_out = reg_file_read_data2;

    shift_out = shift;
    rs_out = rs;
    rt_out = rt;
    rd_out = rd;
  end
endmodule


