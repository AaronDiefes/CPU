module counter_6bit(clk, en, clr, q);
    input clk, en, clr;
    output[5:0] q;

    wire q0, q1, q2, q3, q4, q5;
    wire t1, t2, t3, t4, t5;

    tff tff0(.t(en), .clk(clk), .q(q0), .clr(clr));
    and t_1(t1, q0, en);
    assign q[0] = q0;

    tff tff1(.t(t1), .clk(clk), .q(q1), .clr(clr));
    and t_2(t2, q1, t1);
    assign q[1] = q1;

    tff tff2(.t(t2), .clk(clk), .q(q2), .clr(clr));
    and t_3(t3, q2, t2);
    assign q[2] = q2;

    tff tff3(.t(t3), .clk(clk), .q(q3), .clr(clr));
    and t_4(t4, q3, t3);
    assign q[3] = q3;

    tff tff4(.t(t4), .clk(clk), .q(q4), .clr(clr));
    and t_5(t5, q4, t4);
    assign q[4] = q4;

    tff tff5(.t(t5), .clk(clk), .q(q5), .clr(clr));
    assign q[5] = q5;

endmodule