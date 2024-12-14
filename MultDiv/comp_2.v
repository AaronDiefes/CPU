module comp_2(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [1:0] A, B;
    output EQ0, GT0;

    wire [2:0] select;

    //8:1 mux wires
    wire [7:0] eq_mux_inputs;
    wire [7:0] gt_mux_inputs;

    assign select[2:1] = A;      
    assign select[0] = B[1];  

    wire eq_mux_out, gt_mux_out, notB0;

    not not_B0(notB0, B[0]);


    //2^3 combos with A!, A0, B1 as select bits
    assign eq_mux_inputs[0] = notB0;
    assign eq_mux_inputs[1] = 1'b0;
    assign eq_mux_inputs[2] = B[0];
    assign eq_mux_inputs[3] = 1'b0;
    assign eq_mux_inputs[4] = 1'b0;
    assign eq_mux_inputs[5] = notB0;
    assign eq_mux_inputs[6] = 1'b0;
    assign eq_mux_inputs[7] = B[0];

    assign gt_mux_inputs[0] = 1'b0;
    assign gt_mux_inputs[1] = 1'b0;
    assign gt_mux_inputs[2] = notB0;
    assign gt_mux_inputs[3] = 1'b0;
    assign gt_mux_inputs[4] = 1'b1;
    assign gt_mux_inputs[5] = 1'b0;
    assign gt_mux_inputs[6] = 1'b1;
    assign gt_mux_inputs[7] = notB0;


    mux_8 #(.WIDTH(1)) eq_mux (
        .select(select), .in0(eq_mux_inputs[0]), .in1(eq_mux_inputs[1]), .in2(eq_mux_inputs[2]), .in3(eq_mux_inputs[3]),
        .in4(eq_mux_inputs[4]), .in5(eq_mux_inputs[5]), .in6(eq_mux_inputs[6]), .in7(eq_mux_inputs[7]), .out(eq_mux_out)
    );

    and eq_mux_out_and_EQ1(EQ0, eq_mux_out, EQ1);

    mux_8 #(.WIDTH(1)) gt_mux (
        .select(select), .in0(gt_mux_inputs[0]), .in1(gt_mux_inputs[1]), .in2(gt_mux_inputs[2]), .in3(gt_mux_inputs[3]),
        .in4(gt_mux_inputs[4]), .in5(gt_mux_inputs[5]), .in6(gt_mux_inputs[6]), .in7(gt_mux_inputs[7]), .out(gt_mux_out)
    );

    //wires
    wire noteq1gt1;
    wire eq1notgt1muxout;
    wire noteq1, notgt1;
    wire APosBNeg, notA1;

    not not_eq1(noteq1, EQ1);
    not not_gt1(notgt1, GT1);

   
    and notEQ1_and_GT1(noteq1gt1, noteq1, GT1);
    and EQ1_and_notGT1_and_gt_mux_out(eq1notgt1muxout, EQ1, notgt1, gt_mux_out);

    not not_A_1(notA1, A[1]);
    and A_Pos_B_Neg(APosBNeg, notA1, B[1]);

    or gt0logic(GT0, noteq1gt1, eq1notgt1muxout, APosBNeg);

endmodule