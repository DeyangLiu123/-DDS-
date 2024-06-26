module seg_select(
			input seg_clock,
			input sys_rst,
			input[5:0] Fword1,
			input[7:0] Fword2,
			input[8:0] Pword2,
			output [7:0] seg_output,
			output [7:0] cat_output
);

reg[7:0] seg;
reg[7:0] cat;

	always @(posedge seg_clock or posedge sys_rst) begin
		if(sys_rst) begin 
			seg <= 8'b00000000;
			cat <= 8'b11111111;
		end
		else begin
			if(cat == 8'b11111111) begin
				cat <= 8'b11111110; 
			end 
			else begin
				case(cat)
					8'b10111111: 
								case(Fword1[5:4])
									2'b00:seg <= 8'b11111100;//0
									2'b01:seg <= 8'b01100000;//1
									2'b10:seg <= 8'b11011010;//2
									2'b11:seg <= 8'b11110010;//2
								endcase
					8'b11011111: 
								case(Fword1[3:0])
									4'b0000: seg <= 8'b11111101;
									4'b0001: seg <= 8'b01100001;
									4'b0010: seg <= 8'b11011011;
									4'b0011: seg <= 8'b11110011;
									4'b0100: seg <= 8'b01100111;
									4'b0101: seg <= 8'b10110111;
									4'b0110: seg <= 8'b10111111;
									4'b0111: seg <= 8'b11100001;
									4'b1000: seg <= 8'b11111111;
									4'b1001: seg <= 8'b11110111;
									4'b1010: seg <= 8'b11101111;
									4'b1011: seg <= 8'b00111111;
									4'b1100: seg <= 8'b10011101;
									4'b1101: seg <= 8'b01111011;
									4'b1110: seg <= 8'b10011111;
									4'b1111: seg <= 8'b10001111;
								endcase
					8'b11101111: 
								case(Fword2[7:4])
									4'b0000: seg <= 8'b11111100;
									4'b0001: seg <= 8'b01100000;
									4'b0010: seg <= 8'b11011010;
									4'b0011: seg <= 8'b11110010;
									4'b0100: seg <= 8'b01100110;
									4'b0101: seg <= 8'b10110110;
									4'b0110: seg <= 8'b10111110;
									4'b0111: seg <= 8'b11100000;
									4'b1000: seg <= 8'b11111110;
									4'b1001: seg <= 8'b11110110;
									4'b1010: seg <= 8'b11101110;
									4'b1011: seg <= 8'b00111110;
									4'b1100: seg <= 8'b10011100;
									4'b1101: seg <= 8'b01111010;
									4'b1110: seg <= 8'b10011110;
									4'b1111: seg <= 8'b10001110;
								endcase
					8'b11110111: 
								case(Fword2[3:0])
									4'b0000: seg <= 8'b11111101;
									4'b0001: seg <= 8'b01100001;
									4'b0010: seg <= 8'b11011011;
									4'b0011: seg <= 8'b11110011;
									4'b0100: seg <= 8'b01100111;
									4'b0101: seg <= 8'b10110111;
									4'b0110: seg <= 8'b10111111;
									4'b0111: seg <= 8'b11100001;
									4'b1000: seg <= 8'b11111111;
									4'b1001: seg <= 8'b11110111;
									4'b1010: seg <= 8'b11101111;
									4'b1011: seg <= 8'b00111111;
									4'b1100: seg <= 8'b10011101;
									4'b1101: seg <= 8'b01111011;
									4'b1110: seg <= 8'b10011111;
									4'b1111: seg <= 8'b10001111;
								endcase
					8'b11111011: seg <= 8'b11111101;
					8'b11111101: 
									case(Pword2[8])
										1'b0: seg <= 8'b11111100;
										1'b1: seg <= 8'b01100000;
									endcase
					8'b11111110: 
									case(Pword2[7:4])
										4'b0000: seg <= 8'b11111100;
										4'b0001: seg <= 8'b01100000;
										4'b0010: seg <= 8'b11011010;
										4'b0011: seg <= 8'b11110010;
										4'b0100: seg <= 8'b01100110;
										4'b0101: seg <= 8'b10110110;
										4'b0110: seg <= 8'b10111110;
										4'b0111: seg <= 8'b11100000;
										4'b1000: seg <= 8'b11111110;
										4'b1001: seg <= 8'b11110110;
										4'b1010: seg <= 8'b11101110;
										4'b1011: seg <= 8'b00111110;
										4'b1100: seg <= 8'b10011100;
										4'b1101: seg <= 8'b01111010;
										4'b1110: seg <= 8'b10011110;
										4'b1111: seg <= 8'b10001110;
									endcase
					8'b01111111: 
									case(Pword2[3:0])
										4'b0000: seg <= 8'b11111101;
									   4'b0001: seg <= 8'b01100001;
									   4'b0010: seg <= 8'b11011011;
									   4'b0011: seg <= 8'b11110011;
									   4'b0100: seg <= 8'b01100111;
									   4'b0101: seg <= 8'b10110111;
									   4'b0110: seg <= 8'b10111111;
									   4'b0111: seg <= 8'b11100001;
									   4'b1000: seg <= 8'b11111111;
									   4'b1001: seg <= 8'b11110111;
									   4'b1010: seg <= 8'b11101111;
									   4'b1011: seg <= 8'b00111111;
									   4'b1100: seg <= 8'b10011101;
									   4'b1101: seg <= 8'b01111011;
									   4'b1110: seg <= 8'b10011111;
									   4'b1111: seg <= 8'b10001111;
									endcase
					default:seg <= 8'b00000000;
				endcase	
				cat <= {cat[6:0], cat[7]};
				end
			end
	end
	
	assign seg_output = seg;
	assign cat_output = cat;
	
endmodule			