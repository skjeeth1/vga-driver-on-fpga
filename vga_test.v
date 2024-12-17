module vga_test (
    input inclk, reset,
    input [11:0] color,
    output [11:0] rgb,
    output h_sync, v_sync
);

    wire video_on;
    reg [11:0] rgb_val;

    wire clk;
    clk_wiz_0 CLK (.clk_out1(clk), .reset(reset), .clk_in1(inclk));

    vga_module VGA (.clk(clk), .reset(reset), .video_on(video_on), .h_sync(h_sync), .v_sync(v_sync), .pos_x(), .pos_y());

    always @(posedge clk or posedge reset) begin
        if (reset) rgb_val <= 0;
        else rgb_val <= color;
    end

    assign rgb = video_on ? rgb_val : 12'b0;

endmodule