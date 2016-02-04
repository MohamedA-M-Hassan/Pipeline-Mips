module PC(in, clk, freeze ,out);
  input [31:0] in;
  input clk , freeze;
  output reg [31:0] out;

	always @(posedge clk) begin
		if (freeze !== 1'b1) begin
      #10 out = in;
    end
  end

  initial begin
    out = 32'h0000_0000;
  end
endmodule

module PC_testbench();
  reg [31:0] in;
  reg clk , pcWrite;
  wire [31:0] out;

  PC pc(in, clk, pcWrite, out);

  initial begin
    clk = 0;
    forever #50 clk = ~clk;
  end

  
  initial begin
    in = 32'h1010_1010;
    #100
    pcWrite = 1'b1;
    #5
    in = 32'h1010_1014;
    #300
    pcWrite = 0;
	
    in = 32'h1010_ffff;
    
    #200 $finish;
  end
endmodule
