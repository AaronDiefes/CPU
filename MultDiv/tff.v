module tff(t, clk, q, clr);
    //following t flipflop schematic from lecture
    input t, clk, clr;
    output q;

    wire and1, and2, d;

    and and_1(and1, q, ~t);
    and and_2(and2, t, ~q);

    or D(d, and1, and2);

    dffe_ref dff(.q(q), .d(d), .clk(clk), .en(t), .clr(clr));

endmodule