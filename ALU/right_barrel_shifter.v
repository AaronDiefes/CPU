module right_barrel_shifter(data_operandA, ctrl_shiftamt, data_result);
    input [31:0] data_operandA;
    input [4:0] ctrl_shiftamt;

    output [31:0] data_result;
    wire [31:0] sra16, sra8, sra4, sra2, sra1;
    wire [31:0] final_sra_16, final_sra_8, final_sra_4, final_sra_2;

    //sra 16
    rshift_16bit sra_16(.data_operandA(data_operandA), .data_result(sra16));
    mux_2 shamt_16(.select(ctrl_shiftamt[4]), .in0(data_operandA), .in1(sra16), .out(final_sra_16));

    //sra 8
    rshift_8bit sra_8(.data_operandA(final_sra_16), .data_result(sra8));
    mux_2 shamt_8(.select(ctrl_shiftamt[3]), .in0(final_sra_16), .in1(sra8), .out(final_sra_8));

    //sra 4
    rshift_4bit sra_4(.data_operandA(final_sra_8), .data_result(sra4));
    mux_2 shamt_4(.select(ctrl_shiftamt[2]), .in0(final_sra_8), .in1(sra4), .out(final_sra_4));

    //sra 2
    rshift_2bit sra_2(.data_operandA(final_sra_4), .data_result(sra2));
    mux_2 shamt_2(.select(ctrl_shiftamt[1]), .in0(final_sra_4), .in1(sra2), .out(final_sra_2));

    //sra 1
    rshift_1bit sra_1(.data_operandA(final_sra_2), .data_result(sra1));
    mux_2 shamt_1(.select(ctrl_shiftamt[0]), .in0(final_sra_2), .in1(sra1), .out(data_result));

endmodule