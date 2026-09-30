module fifo (
    input logic clk,
    input logic rst,

    input logic RD,
    input logic WR,

    input logic [7:0] data_in,
    output logic [7:0] data_out,

    output logic empty,
    output logic full
);

    logic [7:0] data [0:3];

    logic [1:0] rd_ptr;
    logic [1:0] wr_ptr;

    logic [2:0] count;

    logic do_read;
    logic do_write;

    assign empty = (count == 3'd0);
    assign full = (count == 3'd4);

    assign do_write = !WR && !full;
    assign do_read = !RD && !empty;

    always_ff @(posedge clk) begin : fifo_block

        if (rst) begin
            rd_ptr <= 2'd0;
            wr_ptr <= 2'd0;
            count <= 3'd0;
            data_out <= 8'd0;
        end

        else begin

            // Write
            if (do_write) begin
                data[wr_ptr] <= data_in;

                if (wr_ptr == 2'd3)
                    wr_ptr <= 2'd0;
                else
                    wr_ptr <= wr_ptr + 1'b1;
            end

            // Read
            if (do_read) begin
                data_out <= data[rd_ptr];

                if (rd_ptr == 2'd3)
                    rd_ptr <= 2'd0;
                else
                    rd_ptr <= rd_ptr + 1'b1;
            end

            // Count
            if (do_write && !do_read)
                count <= count + 1'b1;
            else if (do_read && !do_write)
                count <= count - 1'b1;

        end

    end

endmodule
