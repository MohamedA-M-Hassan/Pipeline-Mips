module Mux2_32b(out, select, in0, in1);
  input select;
  input [31:0] in0, in1;
  output wire [31:0] out;

  assign #10 out = select == 0? in0 : in1;
endmodule

module Mux4_32b(out, select, in0, in1, in2, in3);
  input [1:0] select;
  input [31:0] in0, in1, in2, in3;
  output wire [31:0] out;

  assign #10 out = (select == 2'd0)? in0 : (select == 2'd1)? in1 : (select == 2'd2)? in2 : (select == 2'd3)? in3 : 32'bx;
endmodule

module Mux4_5b(out, select, in0, in1, in2, in3);
  input [1:0] select;
  input [4:0] in0, in1, in2, in3;
  output wire [4:0] out;

  assign #10 out = (select == 2'd0)? in0 : (select == 2'd1)? in1 : (select == 2'd2)? in2 : (select == 2'd3)? in3 : 4'bx;
endmodule
