module bit32_cla(data_operandA, data_operandB, data_cin, sum, overflow);
    
    input[31:0] data_operandA, data_operandB;
    input data_cin;
    output[31:0] sum;
    output overflow;

    //subtraction
    wire [31:0] neg_data_operandB;

    //in-between wires for carry-in
    wire first_Cout, second_Cout, third_Cout, fourth_Cout;

    //wires for c8, c16, c24 calculations//
    
    //c8
    wire c8, P0c0;

    //c16
    wire c16, P1G0, P1P0c0;

    //c24
    wire c24, P2G1, P2P1G0, P2P1P0c0;

    //c32
    wire c32, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0;

    wire P0, P1, P2, P3;
    wire G0, G1, G2, G3;
    wire[7:0] sum1, sum2, sum3, sum4;

    //overflow 
    wire AmsbEqBmsb, CoutEqSummsb;
    
    
    //4 8bit cla's chained together
    bit8_cla first_8(.data_operandA(data_operandA[7:0]), .data_operandB(data_operandB[7:0]), .data_cin(data_cin), .Pout(P0), .Gout(G0), .sum(sum1));

    and P0_c0(P0c0, P0, data_cin);
    or c_8(c8, G0, P0c0);

    bit8_cla second_8(.data_operandA(data_operandA[15:8]), .data_operandB(data_operandB[15:8]), .data_cin(c8), .Pout(P1), .Gout(G1), .sum(sum2));
    and P1_G0(P1G0, P1, G0);
    and P2_P1_c0(P1P0c0, P1, P0, data_cin);
    or c_16(c16, G1, P1G0, P1P0c0);

    bit8_cla third_8(.data_operandA(data_operandA[23:16]), .data_operandB(data_operandB[23:16]), .data_cin(c16), .Pout(P2), .Gout(G2), .sum(sum3));
    and P2_G1(P2G1, P2, G1);
    and P2_P1_G0(P2P1G0, P2, P1, G0);
    and P2_P1_P0_c0(P2P1P0c0, P2, P1, P0, data_cin);
    or c_24(c24, G2, P2G1, P2P1G0, P2P1P0c0);

    bit8_cla fourth_8(.data_operandA(data_operandA[31:24]), .data_operandB(data_operandB[31:24]), .data_cin(c24), .Pout(P3), .Gout(G3), .sum(sum4));

    and P3_G2(P3G2, P3, G2);
    and P3_P2_G1(P3P2G1, P3, P2, G1);
    and P3_P2_P1_G0(P3P2P1G0, P3, P2, P1, G0);
    and P3_P2_P1_P0_c0(P3P2P1P0c0, P3, P2, P1, P0, data_cin);
    or c_32(c32, G3, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0c0);

    //sum
    assign sum[7:0] = sum1;
    assign sum[15:8] = sum2;
    assign sum[23:16] = sum3;
    assign sum[31:24] = sum4;

    //overflow
    xnor A_B_same_signs(AmsbEqBmsb, data_operandA[31], data_operandB[31]);
    xor Cout_neq_sum_msb(CoutEqSummsb, c32, sum[31]);

    and Overflow(overflow, AmsbEqBmsb, CoutEqSummsb);

endmodule