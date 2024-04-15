module tb_matrix_keypad;

    // 参数
    parameter CLK_PERIOD = 10; // 根据需要定义

    // 信号
    reg clk;
    reg reset;
    reg [3:0] row;
    wire [3:0] col;
    wire [4:0] key;
    wire keypress;

    // 实例化DUT
    matrix_keypad uut (
        .clk(clk),
        .reset(reset),
        .row(row),
        .col(col),
        .key(key),
        .keypress(keypress)
    );

    // 时钟生成
    always begin
        # (CLK_PERIOD/2) clk = ~clk;
    end

    // 测试逻辑
    initial begin
        // 初始化
        clk = 0;
        reset = 1;
        row = 4'b1111;

        #CLK_PERIOD; 
        reset = 0;

        // Test cases
        #30 row = 4'b0111; // 按下第一行的键
        #40 row = 4'b1111; // 释放键
        #40 row = 4'b1011; // 按下第二行的键
        #40 row = 4'b1111; // 释放键
        #40 row = 4'b1101; // 按下第三行的键
        #40 row = 4'b1111; // 释放键
        #40 row = 4'b1110; // 按下第四行的键
        #40 row = 4'b1111; // 释放键
        

        // 结束仿真
        $finish;
    end

endmodule
