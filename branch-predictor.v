  module BranchPredictor(clk, Branch, branchRes, out);
  input clk, Branch, branchRes;
  reg [1:0] LastState;
  output out;

  parameter [1:0]
    stronglyTaken = 2'b11,
    weaklyTaken = 2'b10,
    weaklyNotTaken = 2'b01,
    stronglyNotTaken = 2'b00;

  assign out = ((LastState == stronglyTaken) || (LastState == weaklyTaken));

  initial begin
    LastState <= stronglyTaken;
  end
  
  always @(posedge clk) begin
    if (Branch)
      case(LastState)
        stronglyTaken:  if (!branchRes) LastState <= weaklyTaken;
        
        weaklyTaken:  begin
          if (branchRes)  LastState <= stronglyTaken;
          else if (!branchRes)  LastState <= weaklyNotTaken;
        end
        
        weaklyNotTaken:  begin
          if(branchRes) LastState <= weaklyTaken;
          else if (!branchRes) LastState <= stronglyNotTaken;
        end

        stronglyNotTaken:  if (branchRes)  LastState <= weaklyNotTaken;
      endcase
  end
endmodule
