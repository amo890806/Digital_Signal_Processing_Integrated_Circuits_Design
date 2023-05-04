`include "define.vh"
`include "DW02_mult_2_stage_inst.v"

module FIR (
    input clk,
    input rst,
    input en,
    input signed [`DATA_WIDTH-1:0] din,
    output [`DATA_WIDTH-1:0] dout,
    output sample_in,
    output sample_out
);

parameter coeff_0 = 16'h0106;
parameter coeff_1 = 16'h017E;
parameter coeff_2 = 16'h004B;
parameter coeff_3 = 16'hFE80;
parameter coeff_4 = 16'hFECB;
parameter coeff_5 = 16'h01A9;
parameter coeff_6 = 16'h02C9;
parameter coeff_7 = 16'hFF00;
parameter coeff_8 = 16'hFA88;
parameter coeff_9 = 16'hFE5C;
parameter coeff_10 = 16'h0C23;
parameter coeff_11 = 16'h1949;

reg [`DATA_WIDTH-1:0] d_mux_out;
reg [`DATA_WIDTH-1:0] c_mux_out;
reg [`DATA_WIDTH-1:0] a_mux_out;

reg [`DATA_WIDTH-1:0] fifo [0:`FIFO_SIZE-1];

reg signed [`DATA_WIDTH-1:0] buffer_r, buffer_w;

reg signed [`DATA_WIDTH-1:0] add1_r, add2_r, add1_w, add2_w;
wire signed [`DATA_WIDTH-1:0] add;

reg signed [`DATA_WIDTH-1:0] mult1_r, mult2_r, mult1_w, mult2_w;
wire signed [2*`DATA_WIDTH-1:0] mult;
wire signed [`DATA_WIDTH-1:0] mult_trunc, mult1, mult2;

reg [4:0] cnt_r, cnt_w;
reg start_r;

wire d_select, a_select;

reg [`DATA_WIDTH-1:0] dout_r, dout_w;


DW02_mult_2_stage_inst( 
      .inst_A(mult1), 
      .inst_B(mult2), 
      .inst_TC(1'b1), 
      .inst_CLK(clk), 
      .PRODUCT_inst(mult) 
);


//Combinational Logic
assign add = add1_r + add2_r;
//assign mult = mult1_r * mult2_r;
assign mult_trunc = {mult[2*`DATA_WIDTH-1], mult[28:14]};
assign sample_in = (start_r && cnt_r == 0);
assign d_select = cnt_r == 1;
assign a_select = cnt_r == 3;
assign sample_out = cnt_r == 4;
assign dout = dout_r;
assign mult1 = mult1_r;
assign mult2 = mult2_r;

//Data Mux
always @(*) begin
    d_mux_out = (d_select) ? buffer_r : fifo[`FIFO_SIZE-1];
end

//Coeff Mux
always @(*) begin
    case (cnt_r)
        1, 0: c_mux_out = $signed(coeff_0);
        2, 23: c_mux_out = $signed(coeff_1);
        3, 22: c_mux_out = $signed(coeff_2);
        4, 21: c_mux_out = $signed(coeff_3);
        5, 20: c_mux_out = $signed(coeff_4);
        6, 19: c_mux_out = $signed(coeff_5);
        7, 18: c_mux_out = $signed(coeff_6);
        8, 17: c_mux_out = $signed(coeff_7);
        9, 16: c_mux_out = $signed(coeff_8);
        10, 15: c_mux_out = $signed(coeff_9);
        11, 14: c_mux_out = $signed(coeff_10);
        12, 13: c_mux_out = $signed(coeff_11);
        default: c_mux_out = 0;
    endcase
end

//Addend Mux
always @(*) begin
    a_mux_out = (a_select) ? 0 : add;
end

//Buffer
always @(*) begin
    buffer_w = (start_r) ? din : 0;
end

//Counter
always @(*) begin
    if(start_r)begin
        cnt_w = (cnt_r == 23) ? 0 : cnt_r+1;
    end
    else begin
        cnt_w = cnt_r;
    end
end
//always @(posedge clk or posedge rst)begin
//    if(rst)begin
//        cnt_r <= 5'd0;
//    end
//    else begin
//        if(start_r)begin
//            cnt_r <= (cnt_r == 23) ? 0 : cnt_r+1;
//        end
//    end
//end

//Data FIFO
always @(posedge clk or posedge rst) begin
    if(rst)begin
        fifo[0] <= 0;
        fifo[1] <= 0;
        fifo[2] <= 0;
        fifo[3] <= 0;
        fifo[4] <= 0;
        fifo[5] <= 0;
        fifo[6] <= 0;
        fifo[7] <= 0;
        fifo[8] <= 0;
        fifo[9] <= 0;
        fifo[10] <= 0;
        fifo[11] <= 0;
        fifo[12] <= 0;
        fifo[13] <= 0;
        fifo[14] <= 0;
        fifo[15] <= 0;
        fifo[16] <= 0;
        fifo[17] <= 0;
        fifo[18] <= 0;
        fifo[19] <= 0;
        fifo[20] <= 0;
        fifo[21] <= 0;
        fifo[22] <= 0;
        fifo[23] <= 0;
        fifo[24] <= 0;
    end
    else begin
        fifo[0] <= d_mux_out;
        fifo[1] <= fifo[0];
        fifo[2] <= fifo[1];
        fifo[3] <= fifo[2];
        fifo[4] <= fifo[3];
        fifo[5] <= fifo[4];
        fifo[6] <= fifo[5];
        fifo[7] <= fifo[6];
        fifo[8] <= fifo[7];
        fifo[9] <= fifo[8];
        fifo[10] <= fifo[9];
        fifo[11] <= fifo[10];
        fifo[12] <= fifo[11];
        fifo[13] <= fifo[12];
        fifo[14] <= fifo[13];
        fifo[15] <= fifo[14];
        fifo[16] <= fifo[15];
        fifo[17] <= fifo[16];
        fifo[18] <= fifo[17];
        fifo[19] <= fifo[18];
        fifo[20] <= fifo[19];
        fifo[21] <= fifo[20];
        fifo[22] <= fifo[21];
        fifo[23] <= fifo[22];
        fifo[24] <= fifo[23];
    end
end

//Adder
always @(*) begin
    add1_w = mult_trunc;
    add2_w = a_mux_out;
end

//Multiplier
always @(*) begin
    mult1_w = c_mux_out;
    mult2_w = d_mux_out;
end

//Start
//always @(*) begin
//    start_w = (en) ? 1 : start_r;
//end
always @(posedge clk or posedge rst) begin
    if(rst) begin
        start_r <= 0;
    end
    else begin
        start_r <= (en) ? 1 : start_r;
    end
end

//Output
always @(*) begin
    dout_w = (a_select) ? add : 0;
end



//Sequential Logic
always @(posedge clk or posedge rst) begin
    if(rst)begin
        buffer_r <= 0;
        cnt_r <= 0;
        add1_r <= 0;
        add2_r <= 0;
        mult1_r <= 0;
        mult2_r <= 0;
//        start_r <= 0;
        dout_r <= 0;
    end
    else begin
        buffer_r <= buffer_w;
        cnt_r <= cnt_w;
        add1_r <= add1_w;
        add2_r <= add2_w;
        mult1_r <= mult1_w;
        mult2_r <= mult2_w;
//        start_r <= start_w;
        dout_r <= dout_w;
    end
end
    
endmodule
