module C_flag(
    input clk,    // Asynchronous reset to state B
    input[3:0] in,
    output[1:0] C_flag
    );//  
	
    parameter C_F1=2'd0, C_P1=2'd1,C_F2=2'd2,C_P2=2'd3; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        // State transition logic
        case(in)
                4'd0 : next_state = C_F1;
                4'd1 : next_state = C_P1;
                4'd2 : next_state = C_F2;
                4'd3 : next_state = C_P2;
                default : next_state = next_state;
        endcase
    end

    always @(posedge clk) begin    // This is a sequential always block
        // State flip-flops with asynchronous reset
            state <= next_state;
    end

    // Output logic
    assign C_flag = (state == C_F1) ? 2'b00 : (state == C_P1) ? 2'b01 : (state == C_F2) ? 2'b10 : (state == C_P2) ? 2'b11 : 2'b00;

endmodule
