module RegisterFile(read_reg1, read_reg2, write_reg, write_data, RegWrite, clk, read_data1, read_data2);
  input [4:0] read_reg1, read_reg2, write_reg;
  input [31:0] write_data;
  input RegWrite, clk;
  output wire [31:0] read_data1, read_data2;

  reg [31:0] registers [0:31];

  assign #100 read_data1 = registers[read_reg1];
  assign #100 read_data2 = registers[read_reg2];
  
  always @(posedge clk) begin
    if(RegWrite && write_reg != 5'b00000) begin
      registers[write_reg] <= #100 write_data;
    end
  end

  initial begin
    registers[0] = 32'b0;
  end
endmodule

module RegisterFile_testbench;
  reg [5:0] read_reg1, read_reg2, write_reg;
  reg [31:0] write_data;
  reg RegWrite, clk;
  wire [31:0] read_data1, read_data2;

  RegisterFile regs(read_reg1, read_reg2, write_reg, write_data, RegWrite, clk, read_data1, read_data2);

  initial begin
    clk <= 0;
    forever #500 clk <= ~clk;
  end

  initial begin
    read_reg1 <= 1;
    read_reg2 <= 3;
    write_reg <= 3;

    RegWrite = 0;

    #1000
    #100 read_reg1 = 2;

    #100 write_data <= 32'habcdef12;
    #100 RegWrite <= 1;

    #1000 RegWrite <= 0;

    #500 $finish;
  end
endmodule
