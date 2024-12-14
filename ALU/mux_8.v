module mux_8 #(parameter WIDTH = 32)(select, in0, in1, in2, in3, in4, in5, in6, in7, out);
    input [2:0] select;
    input [WIDTH-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output [WIDTH-1:0] out;
    wire [WIDTH-1:0] w1, w2;
    
    mux_4 #(.WIDTH(WIDTH)) mux_top (
        .select(select[1:0]),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(w1)
    );
    
    mux_4 #(.WIDTH(WIDTH)) mux_bottom (
        .select(select[1:0]),
        .in0(in4),
        .in1(in5),
        .in2(in6),
        .in3(in7),
        .out(w2)
    );
    
    mux_2 #(.WIDTH(WIDTH)) mux_final (
        .select(select[2]),
        .in0(w1),
        .in1(w2),
        .out(out)
    );
endmodule