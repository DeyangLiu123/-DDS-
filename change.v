module change(
	input clk,
	input[1:0] C_flag,
	input[3:0] key,
	input reset，
	output[7:0] Fword1,
	output[7:0] Fword2,
	output[8:0] Pword1,
	output[8:0] Pword2
);
	always@(posedge clk or posedge reset) begin
		if(reset) 
			Fword1 <= 7'd1;
			Fword2 <= 7'd1;
			Pword1 <= 8'd0;
			Pword2 <= 8'd0;
		else
		
	
	
	
	
	end 


endmodule