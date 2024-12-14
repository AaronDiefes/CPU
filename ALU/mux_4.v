module mux_4 #(parameter WIDTH = 32)(select, in0, in1, in2, in3, out);
    input [1:0] select;
    input [WIDTH-1:0] in0, in1, in2, in3;
    output [WIDTH-1:0] out;
    wire [WIDTH-1:0] w1, w2;
    
    mux_2 #(.WIDTH(WIDTH)) mux_top (
        .select(select[0]),
        .in0(in0),
        .in1(in1),
        .out(w1)
    );
    
    mux_2 #(.WIDTH(WIDTH)) mux_bottom (
        .select(select[0]),
        .in0(in2),
        .in1(in3),
        .out(w2)
    );
    
    mux_2 #(.WIDTH(WIDTH)) mux_final (
        .select(select[1]),
        .in0(w1),
        .in1(w2),
        .out(out)
    );
endmodule