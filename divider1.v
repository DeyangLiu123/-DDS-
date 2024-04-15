module divider (
    input clk,
    input [6:0] n,
    input reset,
    output output_clk
);
    reg clk_temp;
    reg [6:0] counter_ou = 7'd0;

    always @(posedge clk or posedge reset) begin  
        if(reset) begin  
            counter_ou <= 7'd0;
            clk_temp <= 1'b0;  
        end else if(counter_ou < n/2-1) begin
            counter_ou <= counter_ou + 1'b1;
        end else begin
            counter_ou <= 7'd0;
            clk_temp <= ~clk_temp; 
        end
    end

    assign output_clk = clk_temp;
endmodule