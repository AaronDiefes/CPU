module tristate_32bit(in, oe, out);
    input [31:0] in;
    input oe;
    output [31:0] out;

    //32-bit high impedence or just return in
    assign out = oe ? in : 32'bz;
endmodule