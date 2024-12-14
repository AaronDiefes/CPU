module left_barrel_shifter(data_operandA, ctrl_shiftamt, data_result);
    input [31:0] data_operandA;
    input [4:0] ctrl_shiftamt;

    output [31:0] data_result;
    wire [31:0] sll16, sll8, sll4, sll2, sll1;
    wire [31:0] final_sll_16, final_sll_8, final_sll_4, final_sll_2;

    //sll 16
    lshift_16bit sll_16(.data_operandA(data_operandA), .data_result(sll16));
    mux_2 shamt_16(.select(ctrl_shiftamt[4]), .in0(data_operandA), .in1(sll16), .out(final_sll_16));

    //sll 8
    lshift_8bit sll_8(.data_operandA(final_sll_16), .data_result(sll8));
    mux_2 shamt_8(.select(ctrl_shiftamt[3]), .in0(final_sll_16), .in1(sll8), .out(final_sll_8));

    //sll 4
    lshift_4bit sll_4(.data_operandA(final_sll_8), .data_result(sll4));
    mux_2 shamt_4(.select(ctrl_shiftamt[2]), .in0(final_sll_8), .in1(sll4), .out(final_sll_4));

    //sll 2
    lshift_2bit sll_2(.data_operandA(final_sll_4), .data_result(sll2));
    mux_2 shamt_2(.select(ctrl_shiftamt[1]), .in0(final_sll_4), .in1(sll2), .out(final_sll_2));

    //sll 1
    lshift_1bit sll_1(.data_operandA(final_sll_2), .data_result(sll1));
    mux_2 shamt_1(.select(ctrl_shiftamt[0]), .in0(final_sll_2), .in1(sll1), .out(data_result));

endmodule
