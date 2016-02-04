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
