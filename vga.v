module vga_module #(


    // Parameters for horizontal time sync
    localparam H_DISPLAY = 640,
    localparam H_FPORCH = 16,
    localparam H_SYNC = 96,
    localparam H_BPORCH = 48,
    localparam H_MAX = H_DISPLAY + H_FPORCH + H_SYNC + H_BPORCH,
    localparam START_H_SYNC = H_DISPLAY + H_FPORCH,
    localparam END_H_SYNC = H_DISPLAY + H_FPORCH + H_SYNC,

    // Parameters for vertical time sync
    localparam V_DISPLAY = 480,
    localparam V_FPORCH = 10,
    localparam V_SYNC = 2,
    localparam V_BPORCH = 33,
    localparam V_MAX = V_DISPLAY + V_FPORCH + V_SYNC + V_BPORCH,
    localparam START_V_SYNC = V_DISPLAY + V_FPORCH,
    localparam END_V_SYNC = V_DISPLAY + V_FPORCH + V_SYNC

) (
    input inclk,  // 25.125 Mhz clock
    input reset,  // asynchronous reset
    output h_sync,  // H sync signal active low
    output v_sync,  // V sync signal active low 
    output video_on,  // Color output on signal
    output [9:0] pos_x, pos_y  // pixel location for Ext. ROM
);

    // Clocking Wizard to 25.125 Mhz (Input 100 Mhz)
    clk_wiz_0 CLK (.clk_out1(clk), .reset(reset), .clk_in1(inclk));

    // Control signals reg
    reg [9:0] h_count, v_count;
    reg v_sync_reg, h_sync_reg;
    wire v_sync_next, h_sync_next;
    wire [9:0] h_next, v_next;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
            v_sync_reg <= 0;
            h_sync_reg <= 0;
        end
        else begin
            h_count <= h_next;
            v_count <= v_next;
            v_sync_reg <= v_sync_next;
            h_sync_reg <= h_sync_next;
        end
    end
    
    assign h_next = h_count == H_MAX ? 0 : h_count + 1;
    assign v_next = h_count == H_MAX ? (v_count == V_MAX ? 0 : v_count + 1) : v_count;

    assign v_sync_next = ~(v_count >= START_V_SYNC && v_count <= END_V_SYNC);
    assign h_sync_next = ~(h_count >= START_H_SYNC && h_count <= END_H_SYNC);

    assign video_on = (v_count < V_DISPLAY && h_count < H_DISPLAY);

    assign pos_x = h_count;
    assign pos_y = v_count;
    assign h_sync = h_sync_reg;
    assign v_sync = v_sync_reg;
    
endmodule

