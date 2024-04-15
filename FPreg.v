module FPreg(
	input clk,
	input reset,
	input[4:0] keynum,
	input	pulse,
	output[5:0] Fword1,
	output[7:0] Fword2,
	output[8:0] Pword1,
	output[8:0] Pword2,
	output reg DDS_rst
);

	reg[5:0] r_Fword1;
	reg[7:0] r_Fword2;
	reg[8:0] r_Pword1;
	reg[8:0] r_Pword2;
	reg[5:0] prev_Fword1;
	reg[7:0] prev_Fword2;
	reg[8:0] prev_Pword1;
	reg[8:0] prev_Pword2;


always@(posedge clk or posedge reset) begin
	if(reset) begin
		r_Fword1 <= 6'd1;
		r_Fword2 <= 8'd1;
		r_Pword1 <= 9'd0;
		r_Pword2 <= 9'd0;
	end
	
	else if(pulse) begin
			case(keynum)
				4'b00000: 	r_Fword1 <= r_Fword1 + 1'b1;
				4'b00001: 	r_Fword1	<= r_Fword1 + 4'd10;
				4'b00010: 	r_Fword1 <= 1'b1;
				4'b00011:	r_Fword1 <= 6'd63;
				4'b00100: 	r_Fword2 <= r_Fword2 + 1'b1;
				4'b00101: 	r_Fword2 <= r_Fword2 + 4'd10;
				4'b00110: 	r_Fword2 <= r_Fword2 + 7'd100;
				4'b00111: 	r_Fword2 <= 1'b1;
				4'b01000:	r_Pword1 <= r_Pword1 + 1'b1;
				4'b01001:	r_Pword1 <= r_Pword1 + 4'd10;
				4'b01010:	r_Pword1 <= r_Pword1 + 7'd100;
				4'b01011:	r_Pword1 <= 9'b0;
				4'b01100:	r_Pword2 <= r_Pword2 + 1'b1;
				4'b01101:	r_Pword2 <= r_Pword2 + 4'd10;
				4'b01110: 	r_Pword2 <= r_Pword2 + 7'd100;
				4'b01111:	r_Pword2 <= 9'd0;
				default:;
			endcase
		end
	else if((r_Fword1 != prev_Fword1) || (r_Fword2 != prev_Fword2) || (r_Pword1 != prev_Pword1) || (r_Pword2 != prev_Pword2)) begin
		DDS_rst <= 1'b1;
		prev_Fword1 <= r_Fword1;
		prev_Fword2 <= r_Fword2;
		prev_Pword1 <= r_Pword1;
		prev_Pword2 <= r_Pword2;
	end
	else begin
		DDS_rst <= 1'b0;
		prev_Fword1 <= r_Fword1;
		prev_Fword2 <= r_Fword2;
		prev_Pword1 <= r_Pword1;
		prev_Pword2 <= r_Pword2;
		end
	end
assign Fword1 = r_Fword1;
assign Fword2 = r_Fword2;
assign Pword1 = r_Pword1;
assign Pword2 = r_Pword2;


endmodule