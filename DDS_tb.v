`timescale 1ns/1ns

module DDS_tb;
	reg clk;
	reg reset;
	reg[7:0] Fword;
	reg[8:0] Pword;
	wire[11:0] DA_Data;
	
	DDS DDS(
	 .clk(clk),
	 .reset(reset),
	 .Fword(Fword),
	 .Pword(Pword),
	 .DA_Data(DA_Data)
);	
	
	initial clk = 1;
	always #5 clk = ~ clk;
	
	initial begin
		reset = 1;
		Fword = 1;
		Pword = 0;
		#10;
		reset = 0;
		#25600
		reset = 1;
		Fword = 2;
		Pword = 255;
		#10
		reset = 0;
		#12800
		$finish;
	end
	endmodule