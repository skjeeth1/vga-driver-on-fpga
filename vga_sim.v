module vga_sim (
    
);
    reg clk, reset;
    reg [11:0] color;
    wire [11:0]rgb ;
    wire h_sync, v_sync;
    wire video_on;
    wire [9:0] pos_x, pos_y;

    vga_module V1(clk, reset, h_sync, v_sync, video_on, pos_x, pos_y);

    initial begin
        clk = 0;
        forever #0.04 clk = ~clk;
    end

    initial begin
        color = 0;
        reset = 1; 
        #1 reset = 0;
    end
endmodule