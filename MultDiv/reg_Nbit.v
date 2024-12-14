module reg_Nbit #(parameter WIDTH = 32) (readOut, writeIn, clock, resetn, writeEnable);
    input [WIDTH - 1:0] writeIn;
    input clock, resetn, writeEnable;


    output [WIDTH - 1:0] readOut;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            dffe_ref dff(.d(writeIn[i]), .q(readOut[i]), .clr(resetn), .clk(clock), .en(writeEnable));
        end
    endgenerate

endmodule