module mult_control(booth_bits, multiplicand, partial_product);
    input [2:0] booth_bits;
    input [31:0] multiplicand;

    output [31:0] partial_product;

    wire [31:0] multplicand_neg, multiplicand_2x, multiplicand_2x_neg;

    wire [31:0] multiplicand_logical_neg;

    assign multiplicand_logical_neg = ~multiplicand;
    bit32_cla neg_mult(multplicand_neg, multiplicand_logical_neg, 32'b1);

    assign multiplicand_2x = multiplicand << 1;
    bit32_cla neg_mult_2x(multiplicand_2x_neg, multiplicand_2x, 32'b1);

    mux_8 booth_operation(.select(booth_bits), .in0(32'b0), .in1(multiplicand), .in2(multiplicand), .in3(multiplicand_2x),
    .in4(multiplicand_2x_neg), .in5(multplicand_neg), .in6(multplicand_neg), .in7(32'b0), .out(partial_product));
endmodule