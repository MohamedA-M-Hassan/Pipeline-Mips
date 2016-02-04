module  HazardDetectionUnit(ID_EX_MemRead, ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt, stall, freeze, IF_ID_Write);
	
	input ID_EX_MemRead;
	input [4:0] ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt;
	output reg stall, freeze, IF_ID_Write;

	always @(ID_EX_MemRead or ID_EX_RegisterRt or IF_ID_RegisterRs or IF_ID_RegisterRt)	begin
		if (ID_EX_MemRead && (
				 (ID_EX_RegisterRt == IF_ID_RegisterRs) ||
				 (ID_EX_RegisterRt == IF_ID_RegisterRt)
				)) begin
			stall = 1'b1;
			freeze = 1'b1;
			IF_ID_Write = 1'b1;
		end else begin
			stall = 1'b0;
			freeze = 1'b0;
			IF_ID_Write = 1'b0;
		end
	end
endmodule
