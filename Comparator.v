module Comparator (read_data1 ,read_data2 , copmarator_result);
	input [31:0]read_data1 ,read_data2;
	output 	reg  copmarator_result;
	
	always @ (read_data1 or read_data2) begin
      if ( read_data1 == read_data2 )
        #2	copmarator_result = 1'b1;
      else
        #2	copmarator_result = 1'b0;
		end
endmodule

module Comparator_testbench();
  reg [31:0] read_data1 , read_data2;
  wire copmarator_result;

  Comparator try ( read_data1 , read_data2 , copmarator_result );

  initial begin
    read_data1 <= 32'b0000_0000_0000_0100;
    read_data2 <= 32'b0000_0000_0000_0100;
    #10 read_data1 <= 32'b0000_0000_0000_0100;
    read_data2 <= 32'b0000_0010_0000_0100;
    #10 read_data1 <= 32'b0000_0000_0001_0100;
    read_data2 <= 32'b0000_0000_0000_0100;
  end
endmodule
			
