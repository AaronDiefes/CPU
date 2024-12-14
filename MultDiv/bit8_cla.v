module bit8_cla(data_operandA, data_operandB, data_cin, Pout, Gout, sum);

    input[7:0] data_operandA, data_operandB;
    input data_cin;

    output[7:0] sum;
    output Pout, Gout;

    wire c1, c2, c3, c4, c5, c6, c7;

    wire p0, p1, p2, p3, p4, p5, p6, p7;
    wire g0, g1, g2, g3, g4, g5 ,g6, g7;

    //INTERMEDIATE WIRES//
    //c1 wires
    wire p0c0;

    //c2 wires
    wire p1g0, p1p0c0;

    //c3 wires
    wire p2g1, p2p1g0, p2p1p0c0;

    //c4 wires
    wire p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0;

    //c5 wires
    wire p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0;

    //c6 wires
    wire p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0;

    //c7 wires
    wire p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0;

    //calculate G0 intermediate wires
    wire p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0;

    //GENERATE AND PROPOGATES

    and g_0(g0, data_operandA[0], data_operandB[0]);
    and g_1(g1, data_operandA[1], data_operandB[1]);
    and g_2(g2, data_operandA[2], data_operandB[2]);
    and g_3(g3, data_operandA[3], data_operandB[3]);
    and g_4(g4, data_operandA[4], data_operandB[4]);
    and g_5(g5, data_operandA[5], data_operandB[5]);
    and g_6(g6, data_operandA[6], data_operandB[6]);
    and g_7(g7, data_operandA[7], data_operandB[7]);

    or p_0(p0, data_operandA[0], data_operandB[0]);
    or p_1(p1, data_operandA[1], data_operandB[1]);
    or p_2(p2, data_operandA[2], data_operandB[2]);
    or p_3(p3, data_operandA[3], data_operandB[3]);
    or p_4(p4, data_operandA[4], data_operandB[4]);
    or p_5(p5, data_operandA[5], data_operandB[5]);
    or p_6(p6, data_operandA[6], data_operandB[6]);
    or p_7(p7, data_operandA[7], data_operandB[7]);

    //c0
    xor sum_0(sum[0], data_operandA[0], data_operandB[0], data_cin);

    //c1
    and p0_c0(p0c0, p0, data_cin);
    
    or c_1(c1, g0, p0c0);

    xor sum_1(sum[1], data_operandA[1], data_operandB[1], c1);


    //c2
    and p1_g0(p1g0, p1, g0);
    and p1_p0_c0(p1p0c0, p1, p0, data_cin);

    or c_2(c2, g1, p1g0, p1p0c0);

    xor sum_2(sum[2], data_operandA[2], data_operandB[2], c2);

    //c3
    and p2_g2(p2g1, p2, g1);
    and p2_p1_g0(p2p1g0, p2, p1, g0);
    and p2_p1_p0_c0(p2p1p0c0, p2, p1, p0, data_cin);

    or c_3(c3, g2, p2g1, p2p1g0, p2p1p0c0);

    xor sum_3(sum[3], data_operandA[3], data_operandB[3], c3);

    //c4
    and p3_g2(p3g2, p3, g2);
    and p3_p2_g1(p3p2g1, p3, p2, g1);
    and p3_p2_p1_g0(p3p2p1g0, p3, p2, p1, g0);
    and p3_p2_p1_p0_c0(p3p2p1p0c0, p3, p2, p1, p0, data_cin);

    or c_4(c4, g3, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0);

    xor sum_4(sum[4], data_operandA[4], data_operandB[4], c4);

    //c5
    and p4_g3(p4g3, p4, g3);
    and p4_p3_g2(p4p3g2, p4, p3, g2);
    and p4_p3_p2_g1(p4p3p2g1, p4, p3, p2, g1);
    and p4_p3_p2_p1_g0(p4p3p2p1g0, p4, p3, p2, p1, g0);
    and p4_p3_p2_p1_p0_c0(p4p3p2p1p0c0, p4, p3, p2, p1, p0, data_cin);

    or c_5(c5, g4, p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0);

    xor sum_5(sum[5], data_operandA[5], data_operandB[5], c5);

    //c6
    and p5_g4(p5g4, p5, g4);
    and p5_p4_g3(p5p4g3, p5, p4, g3);
    and p5_p4_p3_g2(p5p4p3g2, p5, p4, p3, g2);
    and p5_p4_p3_p2_g1(p5p4p3p2g1, p5, p4, p3, p2, g1);
    and p5_p4_p3_p2_p1_g0(p5p4p3p2p1g0, p5, p4, p3, p2, p1, g0);
    and p5_p4_p3_p2_p1_p0_c0(p5p4p3p2p1p0c0, p5, p4, p3, p2, p1, p0, data_cin);

    or c_6(c6, g5, p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0);

    xor sum_6(sum[6], data_operandA[6], data_operandB[6], c6);

    //c7
    and p6_p5(p6g5, p6, g5);
    and p6_p5_g4(p6p5g4, p6, p5, g4);
    and p6_p5_p4_g3(p6p5p4g3, p6, p5, p4, g3);
    and p6_p5_p4_p3_g2(p6p5p4p3g2, p6, p5, p4, p3, g2);
    and p6_p5_p4_p3_p2_g1(p6p5p4p3p2g1, p6, p5, p4, p3, p2, g1);
    and p6_p5_p4_p3_p2_p1_g0(p6p5p4p3p2p1g0, p6, p5, p4, p3, p2, p1, g0);
    and p6_p5_p4_p3_p2_p1_p0_c0(p6p5p4p3p2p1p0c0, p6, p5, p4, p3, p2, p1, p0, data_cin);

    or c_7(c7, g6, p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0);

    xor sum_7(sum[7], data_operandA[7], data_operandB[7], c7);

    
    //Get P0 and G0 (first 8 bits)
    and P_out(Pout, p7, p6, p5, p4, p3, p2, p1, p0);

    and p7_g6(p7g6, p7, g6);
    and p7_p6_g5(p7p6g5, p7, p6, g5);
    and p7_p6_p5_g4(p7p6p5g4, p7, p6, p5, g4);
    and p7_p6_p5_p4_g3(p7p6p5p4g3, p7, p6, p5, p4, g3);
    and p7_p6_p5_p4_p3_g2(p7p6p5p4p3g2, p7, p6, p5, p4, p3, g2);
    and p7_p6_p5_p4_p3_p2_g1(p7p6p5p4p3p2g1, p7, p6, p5, p4, p3, p2, g1);
    and p7_p6_p5_p4_p3_p2_p1_g0(p7p6p5p4p3p2p1g0, p7, p6, p5, p4, p3, p2, p1, g0);

    or G_out(Gout, g7, p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0);
    
endmodule