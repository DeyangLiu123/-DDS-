module FPreg_tb();


    reg clk;
    reg reset;
    reg [4:0] keynum;
    reg pulse;
    wire [5:0] Fword1;
    wire [7:0] Fword2;
    wire [8:0] Pword1;
    wire [8:0] Pword2;
	 wire DDS_rst;


    FPreg uut (
        .clk(clk),
        .reset(reset),
        .keynum(keynum),
        .pulse(pulse),
        .Fword1(Fword1),
        .Fword2(Fword2),
        .Pword1(Pword1),
        .Pword2(Pword2),
		  .DDS_rst(DDS_rst)
    );


    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 1;
        reset = 1;
        keynum = 5'b10000;
        pulse = 0;
		  
		  #20 reset = 0;
				keynum = 5'd0;
		  #9 	pulse = 1;
		  #10 pulse = 0;
				keynum = 5'd5;
		  #30 pulse = 1;
		  #10 pulse = 0;
				keynum = 5'd14;
			#30 pulse = 1;
			#10 pulse = 0;
			keynum = 5'b10000;
			
       
        
        #50 $finish; 
    end

endmodule
