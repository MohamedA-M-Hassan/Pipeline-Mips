module ForwardingUnit (MEM_WB_RegWrite ,EX_MEM_RegWrite, EX_MEM_RegisterRd ,
						MEM_WB_RegisterRd , ID_EX_RegisterRs , ID_EX_RegisterRt , ForwardA , ForwardB);
	input    MEM_WB_RegWrite , EX_MEM_RegWrite , EX_MEM_RegisterRd ,
					MEM_WB_RegisterRd , ID_EX_RegisterRs , ID_EX_RegisterRt ;
	
	output  reg [1:0] ForwardA , ForwardB ;
	
	initial 
		begin
			// Ex Hazard   A
			if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
				&& (EX_MEM_RegisterRd == ID_EX_RegisterRs))
			
				ForwardA = 2'b10 ;
			
			// Mem Hazard A
			else if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)
				&& (MEM_WB_RegisterRd == ID_EX_RegisterRs))
	
				ForwardA = 2'b01 ;
			// Ex Hazard B  	
			if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
				&& (EX_MEM_RegisterRd == ID_EX_RegisterRt))
			
				ForwardB = 2'b10  ;
				
		
			// // Mem Hazard B	
			else if ( MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)
				&& (MEM_WB_RegisterRd == ID_EX_RegisterRt))

				ForwardB = 2'b01;
		end		
		
endmodule

module ForwardingUnit_test();
  reg MEM_WB_RegWrite ,EX_MEM_RegWrite, EX_MEM_RegisterRd ,
						MEM_WB_RegisterRd , ID_EX_RegisterRs , ID_EX_RegisterRt ;
  wire  ForwardA , ForwardB;

  ForwardingUnit try (MEM_WB_RegWrite ,EX_MEM_RegWrite, EX_MEM_RegisterRd ,
						MEM_WB_RegisterRd , ID_EX_RegisterRs , ID_EX_RegisterRt , ForwardA , ForwardB);

  initial begin
    MEM_WB_RegWrite= 1;
    EX_MEM_RegWrite <= 5;
    EX_MEM_RegisterRd = 6;
	ID_EX_RegisterRs =6;
	#100 
	MEM_WB_RegWrite = 1;
	MEM_WB_RegisterRd = 13;
	MEM_WB_RegisterRd =	12;
	ID_EX_RegisterRs   =12;
  end
endmodule