module  HazardDetectionUnit( ID_EX_MemRead , ID_EX_RegisterRt , IF_ID_RegisterRs , IF_ID_RegisterRt ,
							stall , pcWrite , IF_ID_Write);
	
	input ID_EX_MemRead , ID_EX_RegisterRt , IF_ID_RegisterRs , IF_ID_RegisterRt ;
	output reg stall , pcWrite , IF_ID_Write ;

	initial
	begin
		if 	(ID_EX_MemRead && 
			( (ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt) ) )
			begin
				
				stall = 1'b1 ;
				pcWrite = 1'b1;
				IF_ID_Write = 1'b1 ;
				
			end	
		else  
			begin
				
				stall = 1'b0 ;
				pcWrite = 1'b0;
				IF_ID_Write = 1'b0 ;
				
			end
			
	end		   
endmodule	