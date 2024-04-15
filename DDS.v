module DDS(
	input clk,
	input reset,
	input[7:0] Fword,
	input[8:0] Pword,
	output[11:0] DA_Data
);	
	reg[7:0] r_Fword;
	reg[8:0] r_Pword;
	
	reg[8:0] Fcnt;
	
	wire[8:0] rom_addr;	
	
	always@(posedge clk) begin
		r_Fword <= Fword;
		r_Pword <= Pword;
	end
	
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			Fcnt <= 9'b000000000;
		end
		else 
			Fcnt <= Fcnt + r_Fword;
	end
	
	
	assign rom_addr = Fcnt + r_Pword;
	
	rom rom(
		.clk(clk),
		.address(rom_addr),
		.data(DA_Data)
	);
	
	
endmodule