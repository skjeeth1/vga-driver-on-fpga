module vga_module #(

    localparam H_DISPLAY = 640,
    localparam H_FPORCH = 16,
    localparam H_SYNC = 96,
    localparam H_BPORCH = 48,
    localparam H_MAX = H_DISPLAY + H_FPORCH + H_SYNC + H_BPORCH,
    localparam START_H_SYNC = H_DISPLAY + H_FPORCH,
    localparam END_H_SYNC = H_DISPLAY + H_FPORCH + H_SYNC,

    localparam V_DISPLAY = 480,
    localparam V_FPORCH = 10,
    localparam V_SYNC = 2,
    localparam V_BPORCH = 33,
    localparam V_MAX = V_DISPLAY + V_FPORCH + V_SYNC + V_BPORCH,
    localparam START_V_SYNC = V_DISPLAY + V_FPORCH,
    localparam END_V_SYNC = V_DISPLAY + V_FPORCH + V_SYNC

) (
    input clk, 
    input reset,
    output h_sync, v_sync, video_on,
    output [9:0] pos_x, pos_y
);

    reg [9:0] h_count, v_count;
    wire [9:0] h_next, v_next;

    always @(posedge clk) begin
        h_count <= h_next;
        v_count <= v_next;
    end
    
    assign h_next = h_count == H_MAX ? 0 : h_count + 1;
    assign v_next = h_count == H_MAX ? (v_count == V_MAX ? 0 : v_count + 1) : v_count;

    assign v_sync = v_count >= START_V_SYNC && v_count <= END_V_SYNC;
    assign h_sync = h_count >= START_H_SYNC && h_count <= END_H_SYNC;

    assign video_on = v_count < V_DISPLAY && h_count < H_DISPLAY;
    
endmodule