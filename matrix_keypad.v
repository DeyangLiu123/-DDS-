module matrix_keypad(
    input clk,            // 主时钟
    input reset,          // 复位信号
    input [3:0] row,      // 从键盘驱动的行信号
    output reg [3:0] col, // 从键盘驱动的列信号
    output reg [4:0] key, // 输出的键值
    output reg keypress   // 键被按下的脉冲信号
);

    parameter idle=3'd0,check_1st=3'd1,check_2nd=3'd2,check_3rd=3'd3,check_4th=3'd4;
    
    reg[2:0] present_state, next_state;
    reg [4:0] prev_key = 5'b10000; // 上一个时钟周期的键值

    always @(posedge clk or posedge reset) begin
        if (reset) begin  
            present_state <= idle; 
        end 
        else begin
            present_state <= next_state;   
    end
	 end

    always @(*) begin
        case (present_state)
            idle:begin
						if(row == 4'b1111) next_state = idle;
						else next_state = check_1st;
					end
					check_1st:begin
						if(row == 4'b1111) next_state = check_2nd;
						else next_state = check_1st;
					end
					check_2nd:begin
						if(row == 4'b1111) next_state = check_3rd;
						else next_state = check_2nd;
					end
					check_3rd:begin
						if(row == 4'b1111) next_state = check_4th;
						else next_state = check_3rd;
					end
					check_4th:begin
						if(row == 4'b1111) next_state = idle;
						else next_state = check_4th;
					end
        endcase
    end

    always@(present_state) begin
		case(present_state)
			idle: col = 4'b0000;
			check_1st: col = 4'b0111;
			check_2nd: col = 4'b1011;
			check_3rd: col = 4'b1101;
			check_4th: col = 4'b1110;
		endcase
    end

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            key <= 5'b10000;
            prev_key <= 5'b10000;
        end
        else begin
            case(col)
                4'b0111:
						case(row)
							4'b0111: key <= 5'b00011; 
							4'b1011: key <= 5'b00111; 
							4'b1101: key <= 5'b01011; 
							4'b1110: key <= 5'b01111; 
							default: key <= 5'b10000;
						endcase
					4'b1011:
						case(row)
								4'b0111: key <= 5'b00010; 
								4'b1011: key <= 5'b00110; 
								4'b1101: key <= 5'b01010; 
								4'b1110: key <= 5'b01110; 
								default: key <= 5'b10000; 
							endcase
					4'b1101:
						case(row)
								4'b0111: key <= 5'b00001; 
								4'b1011: key <= 5'b00101; 
								4'b1101: key <= 5'b01001; 
								4'b1110: key <= 5'b01101; 
								default: key <= 5'b10000; 
							endcase
					4'b1110:
						case(row)
								4'b0111: key <= 5'b00000; 
								4'b1011: key <= 5'b00100; 
								4'b1101: key <= 5'b01000; 
								4'b1110: key <= 5'b01100; 
								default: key <= 5'b10000; 
							endcase
					default:key <= 5'b10000;
			endcase

            // Generate keypress pulse only when the key value changes
            if (key != prev_key) begin
                keypress <= 1'b1;
                prev_key <= key;
            end
            else begin
                keypress <= 1'b0;
					 prev_key <= key;
            end
        end
    end

endmodule
