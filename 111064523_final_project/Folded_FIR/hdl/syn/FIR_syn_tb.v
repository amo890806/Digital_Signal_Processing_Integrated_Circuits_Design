`timescale 1ns/10ps
`define CYCLE 2.4
`define DELAY 3
`define INPUT "../sim/input_hex.txt"
`define GOLDEN "../sim/output_hex.txt"

`include "../src/define.vh"

module FIR_tb;

integer i, j, error;
integer a;

reg [`DATA_WIDTH-1:0] input_mem [0:`ROM_INPUT_MEM_SIZE-1];
reg [`DATA_WIDTH-1:0] golden_mem [0:`ROM_OUTPUT_MEM_SIZE-1];
reg [`DATA_WIDTH-1:0] output_mem [0:`ROM_OUTPUT_MEM_SIZE-1];

reg clk;
reg rst;
reg en;
reg signed [`DATA_WIDTH-1:0] din;
wire [`DATA_WIDTH-1:0] dout;
wire sample_in;
wire sample_out;

FIR u_fir(
    .clk(clk),
    .rst(rst),
    .en(en),
    .din(din),
    .dout(dout),
    .sample_in(sample_in),
    .sample_out(sample_out)
);

always #(`CYCLE/2) clk = ~clk;

initial begin
    $readmemh(`INPUT, input_mem);
    $readmemh(`GOLDEN, golden_mem);
end

initial begin
    clk = 0; rst = 1; i=0; error=0; en = 0;
    #(5*`CYCLE/2) rst = 0;
    #`CYCLE en = 1;
    #(3*`CYCLE/2) j=0;
    wait(i == `ROM_INPUT_MEM_SIZE);
    #`CYCLE en = 0;
    wait(j == `ROM_OUTPUT_MEM_SIZE);
    for(j=0; j<`ROM_OUTPUT_MEM_SIZE; j=j+1)begin
        if(output_mem[j] !== golden_mem[j])begin
            error = error + 1;
            $display("Error!!, At mem[%d], output=%d, golden=%d", j, output_mem[j], golden_mem[j]);
        end
        else begin
            $display("Correct!!, At mem[%d], output=%d, golden=%d", j, output_mem[j], golden_mem[j]);
        end
    end
    if(error == 0)begin
        $display("/********************/");
        $display("\nSimulation pass!!!");
        $display("Totally has %d errors\n", error);
        $display("/********************/");
    end
    else begin
        $display("/********************/");
        $display("\nSimulation Failed!!!\n");
        $display("\nTotally has %d errors\n", error);
        $display("/********************/");
    end
    #10 $finish;
end


always @(negedge clk) begin
    if(!rst)begin
        if(j<`ROM_OUTPUT_MEM_SIZE)begin
            if(i>1 && sample_in)begin
                j = j+1;
            end
            else begin
                j = j;
            end

            if(sample_out)begin
                output_mem[j] = dout;
            end
        end
        else begin
            j = j;
        end
    end
end

always @(negedge clk) begin
    if(en && sample_in)begin
        din = input_mem[i];
    end
    else begin
        din = 0;
    end

    if(sample_in)begin
        if(i<`ROM_INPUT_MEM_SIZE)begin
            i = i+1;
        end
        else begin
            i = i;
        end
    end
end

initial begin
    //$dumpfile("FIR.vcd");
    //$dumpvars;
    //$dumpvars(0, fir);
    //for(a=0; a<`ORDER+2; a=a+1)begin
    //    $dumpvars(1, fir.fifo[a]);
    //end

    $sdf_annotate("./FIR_syn.sdf", u_fir);
    $fsdbDumpfile("FIR_syn.fsdb");
    $fsdbDumpvars;
    $fsdbDumpMDA();
end



endmodule
