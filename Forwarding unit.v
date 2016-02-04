module ForwardingUnit (MEM_WB_RegWrite ,EX_MEM_RegWrite, EX_MEM_RegisterRd ,
						MEM_WB_RegisterRd , ID_EX_RegisterRs , ID_EX_RegisterRt , ForwardA , ForwardB);
	input   [31:0] MEM_WB_RegWrite , EX_MEM_RegWrite , EX_MEM_RegisterRd ,
					MEM_WB_RegisterRd , ID_EX_RegisterRs , ID_EX_RegisterRt ;
	
	output   [1:0] ForwardA , ForwardB ;
	
 
			// Ex Hazard
			if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
				&& (EX_MEM_RegisterRd == ID_EX_RegisterRs))
			
			assign	ForwardA = 10 ;
			
			if (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
				&& (EX_MEM_RegisterRd == ID_EX_RegisterRt))
			
			assign	ForwardB = 10  ;
				
				// Mem Hazard 
			if (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)
				!&(EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs))
				&& (MEM_WB_RegisterRd == ID_EX_RegisterRs))
	
			assign	ForwardA = 01 ;
				
			if ( MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)
				!& (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRt))
				&& (MEM_WB_RegisterRd == ID_EX_RegisterRt))

			assign	ForwardB = 01  ;
				
		
endmodule