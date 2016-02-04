module ForwardingUnit (MEM_WB_RegWrite ,EX_MEM_RegWrite, EX_MEM_RegisterRd ,
						MEM_WB_RegisterRd , ID_EX_RegisterRs , ID_EX_RegisterRt , ForwardA , ForwardB);
	input MEM_WB_RegWrite, EX_MEM_RegWrite;
	input [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt;
	
	output reg [1:0] ForwardA , ForwardB;
	
	always @(MEM_WB_RegWrite or EX_MEM_RegWrite, EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt)	begin
			// Ex Hazard A
			if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs))
				ForwardA = 2'b10;
			
			// Mem Hazard A
			else if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs))
				ForwardA = 2'b01;

			else
				ForwardA = 2'b00;

			// Ex Hazard B
			if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRt))
				ForwardB = 2'b10;

			// Mem Hazard B
			else if ( MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRt))
				ForwardB = 2'b01;

			else
				ForwardB = 2'b00;
		end
endmodule

module ForwardingUnit_test();
	reg MEM_WB_RegWrite, EX_MEM_RegWrite;
	reg [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt;
	
	wire [1:0] ForwardA , ForwardB;

  ForwardingUnit try (MEM_WB_RegWrite ,EX_MEM_RegWrite, EX_MEM_RegisterRd ,
						MEM_WB_RegisterRd , ID_EX_RegisterRs , ID_EX_RegisterRt , ForwardA , ForwardB);

  initial begin
		MEM_WB_RegWrite <= 1;
		MEM_WB_RegisterRd = 5'd6;

		EX_MEM_RegWrite <= 1;
		EX_MEM_RegisterRd = 5'd6;

		ID_EX_RegisterRs = 5'd6;
		ID_EX_RegisterRt = 5'd5;
		#100

		MEM_WB_RegWrite <= 1;
		MEM_WB_RegisterRd = 5'd13;

		EX_MEM_RegWrite <= 1;
		EX_MEM_RegisterRd = 5'd12;

		ID_EX_RegisterRs = 5'd12;
		ID_EX_RegisterRt = 5'd13;
		#100

		MEM_WB_RegWrite <= 1;
		MEM_WB_RegisterRd = 5'd13;

		EX_MEM_RegWrite <= 0;
		EX_MEM_RegisterRd = 5'd12;

		ID_EX_RegisterRs = 5'd12;
		ID_EX_RegisterRt = 5'd13;
		#100

		MEM_WB_RegWrite <= 0;
		MEM_WB_RegisterRd = 5'd13;

		EX_MEM_RegWrite <= 1;
		EX_MEM_RegisterRd = 5'd12;

		ID_EX_RegisterRs = 5'd12;
		ID_EX_RegisterRt = 5'd13;
  end
endmodule
