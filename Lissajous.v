/**********************************************************
// Copyright 2023.11.01-2023.11.15
// Contact with 210124996@qq.com
================ Lissajous.v ======================
>> Author       : Liu Deyang
>> Date         : 2023.11.01
>> Description  : DDS Lissajous
>> note         : (1)Other similar code is based on modifications to this design.
>>					 : (2)The copyright of the core FRreg.v and matrix_keypad.v belongs to the author, and no one is allowed to copy.
>>              : (3)The phase difference carries a minus sign.
>>					 : (4)Top-Level Entity 
************************************************************/
module Lissajous(
	input clk,
	input reset,
	input [3:0] row,
	output[3:0] col, 
	output [7:0] seg_output,
	output [7:0] cat_output,
	output cs_o,
   output  data_o,
	output dclock_o
);

	wire main_clk;
	wire clk1;
	wire[11:0] data1;
	wire[11:0] data2;
	wire[4:0] keynum;
	wire pulse;
	wire[5:0] Fword1;
	wire[7:0] Fword2;
	wire[8:0] Pword1;
	wire[8:0] Pword2;
	wire[3:0] r_col;
	wire DDS_rst;

	DAC DAC(
		.clk_i(main_clk),
		.reset_i(reset),
		.dataa(data2),
		.datab(data1),
		.cs_o(cs_o),
		.data_o(data_o),
		.dclock_o(dclock_o)
	);

	matrix_keypad matrix_keypad(
		  .clk(clk1),            
		  .reset(reset),          
		  .row(row),      
		  .col(col), 
		  .key(keynum), 
		  .keypress(pulse) 
);

	DDS DDS1(
		 .clk(clk1),
		 .reset(DDS_rst),
		 .Fword({2'b0,Fword1}),
		 .Pword(Pword1),
		 .DA_Data(data1)
);	
	DDS DDS2(
		 .clk(clk1),
		 .reset(DDS_rst),
		 .Fword(Fword2),
		 .Pword(Pword2),
		 .DA_Data(data2)
);	
	
	divider divider1(
     .clk(clk),
     .n(7'd6),
     .reset(reset),
     .output_clk(main_clk)
);
	divider divider2(
     .clk(main_clk),
     .n(7'd68),
     .reset(reset),
     .output_clk(clk1)
);
	
	FPreg FPreg(
		.clk(clk1),
		.reset(reset),
		.keynum(keynum),
		.pulse(pulse),
		.Fword1(Fword1),
		.Fword2(Fword2),
		.Pword1(Pword1),
		.Pword2(Pword2),
		.DDS_rst(DDS_rst)
);

	seg_select seg_select(
		.seg_clock(clk1),
		.sys_rst(reset),
		.Fword1(Fword1),
		.Fword2(Fword2),
		.Pword2(Pword2),
		.seg_output(seg_output),
		.cat_output(cat_output)
);


endmodule