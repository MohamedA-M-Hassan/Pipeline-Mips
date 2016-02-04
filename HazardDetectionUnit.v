module HazardDetectionUnit(Copmarator_result, Branch, ID_EX_MemRead, ID_EX_RegisterRt, ID_EX_RegWrite, ID_EX_Write_Reg, EX_MEM_MemRead, EX_MEM_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt, control_flush, pc_freeze, IF_ID_freeze, take_branch, IF_ID_flush);
	
	input Copmarator_result, Branch, ID_EX_MemRead, EX_MEM_MemRead, ID_EX_RegWrite;
	input [4:0] ID_EX_RegisterRt, ID_EX_Write_Reg, EX_MEM_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt;
	output reg control_flush, pc_freeze, IF_ID_freeze, take_branch, IF_ID_flush;

	always @(Branch or ID_EX_MemRead or EX_MEM_MemRead or ID_EX_RegWrite or ID_EX_RegisterRt or ID_EX_Write_Reg or EX_MEM_RegisterRt or IF_ID_RegisterRs or IF_ID_RegisterRt)	begin
		if (
			  (ID_EX_MemRead && (
						 (ID_EX_RegisterRt == IF_ID_RegisterRs) ||
						 (ID_EX_RegisterRt == IF_ID_RegisterRt)
				)) ||
				(Branch && EX_MEM_MemRead && (
						 (EX_MEM_RegisterRt == IF_ID_RegisterRs) ||
						 (EX_MEM_RegisterRt == IF_ID_RegisterRt)
						)) ||
				(Branch && ID_EX_RegWrite && !ID_EX_MemRead && (
						 (ID_EX_Write_Reg == IF_ID_RegisterRs) ||
						 (ID_EX_Write_Reg == IF_ID_RegisterRt)
						))
				) begin
			control_flush = 1'b1;
			pc_freeze = 1'b1;
			IF_ID_freeze = 1'b1;
		end else begin
			control_flush = 1'b0;
			pc_freeze = 1'b0;
			IF_ID_freeze = 1'b0;
		end
	end

	always @(Branch or Copmarator_result) begin
		if(Branch && Copmarator_result == 1'b1) begin
			take_branch = 1'b1;
			IF_ID_flush = 1'b1;
		end
		else begin
			take_branch = 1'b0;
			IF_ID_flush = 1'b0;
		end
	end
endmodule
