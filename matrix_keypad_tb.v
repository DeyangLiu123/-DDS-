`timescale 1ns / 1ps

module matrix_keypad_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [3:0] row;

    // Outputs
    wire [3:0] col;
    wire [4:0] key;
    wire keypress;

    // 实例化待测试模块
    matrix_keypad uut (
        .clk(clk), 
        .reset(reset), 
        .row(row), 
        .col(col), 
        .key(key), 
        .keypress(keypress)
    );

    // 生成时钟信号
    always #5 clk = ~clk;

    // 测试过程
    initial begin
        // 初始化
        clk = 1;
        reset = 1;
        row = 4'b1111;

        // 等待两个时钟周期后释放复位
        #20;
        reset = 0;

        // 循环测试不同的按键组合
        #13; row = 4'b1011; 
		  #8; row = 4'b1111;
		  #10; row = 4'b1011;
		  #40; row = 4'b1111;
		  #40; 

        // 模拟结束，观察结果
        $finish;
    end
      
endmodule
