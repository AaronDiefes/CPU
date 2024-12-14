module reg_64bit (readOut, writeIn, clock, resetn, writeEnable);
    input [63:0] writeIn;
    input clock, resetn, writeEnable;


    output [63:0] readOut;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin
            dffe_ref dff(.d(writeIn[i]), .q(readOut[i]), .clr(resetn), .clk(clock), .en(writeEnable));
        end
    endgenerate

endmodule