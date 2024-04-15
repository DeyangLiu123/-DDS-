module tb_seg_select;

    // Declare the signals
    reg seg_clock;
    reg sys_rst;
    reg [5:0] Fword1;
    reg [7:0] Fword2;
    reg [8:0] Pword2;
    wire [7:0] seg_output;
    wire [7:0] cat_output;

    // Instantiate the design under test (DUT)
    seg_select uut (
        .seg_clock(seg_clock),
        .sys_rst(sys_rst),
        .Fword1(Fword1),
        .Fword2(Fword2),
        .Pword2(Pword2),
        .seg_output(seg_output),
        .cat_output(cat_output)
    );

    // Clock generation
    always begin
        #5 seg_clock = ~seg_clock;
    end

    // Test sequence
    initial begin
        // Initialize signals
        seg_clock = 0;
        sys_rst = 1;
        Fword1 = 6'b0;
        Fword2 = 8'b0;
        Pword2 = 9'b0;

        // Reset pulse
        #10 sys_rst = 0;
        #10 sys_rst = 1;
        #10 sys_rst = 0;

        // Test cases
        #10 Fword1 = 6'b000001; Fword2 = 8'b00000010; Pword2 = 9'b010000000;

        // ... Add more test cases as needed ...

        // Finish the simulation
        #100 $finish;
    end

endmodule
