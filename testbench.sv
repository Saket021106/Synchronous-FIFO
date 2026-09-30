`timescale 1ns / 1ps

module tb_fifo();

    reg clk;
    reg rst;
    reg RD;
    reg WR;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire empty;
    wire full;

    fifo uut (
        .clk(clk),
        .rst(rst),
        .RD(RD),
        .WR(WR),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, tb_fifo);

        $monitor("Time=%0t | CLK=%b | RD=%b WR=%b | data_in=%h | data_out=%h | empty=%b full=%b | rd_ptr=%d wr_ptr=%d count=%d",
                 $time, clk, RD, WR, data_in, data_out, empty, full,
                 uut.rd_ptr, uut.wr_ptr, uut.count);

        clk = 1'b0;
        rst = 1'b1;
        RD = 1'b1;
        WR = 1'b1;
        data_in = 8'h00;

        #10;
        rst = 1'b0;

        // Write 10
        WR = 1'b0;
        data_in = 8'h10;
        #10;

        // Write 20
        data_in = 8'h20;
        #10;

        // Write 30
        data_in = 8'h30;
        #10;

        // Write 40
        data_in = 8'h40;
        #10;

        // FIFO should now be full
        WR = 1'b1;
        #10;

        // Read 10
        RD = 1'b0;
        #10;

        // Read 20
        #10;

        // Read 30
        #10;

        // Read 40
        #10;

        // FIFO should now be empty
        RD = 1'b1;
        #10;

        // Test simultaneous write and read
        WR = 1'b0;
        RD = 1'b0;
        data_in = 8'h50;
        #10;

        // Stop read/write
        WR = 1'b1;
        RD = 1'b1;
        #10;

        $finish;
    end

endmodule
