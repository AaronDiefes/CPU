module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:

    wire [31:0] sum;
    wire [31:0] not_data_operandB;
    wire [31:0] CLA_B;
    wire [31:0] left_shift_out;
    wire [31:0] right_shift_out;
    wire [31:0] and_out;
    wire [31:0] or_out;

    wire not_sum_msb;
    wire EQ0, GT0;
    wire not_greater_than;

 
    bit32_not negB(.data_operandA(data_operandB), .data_result(not_data_operandB));
    mux_2 #(.WIDTH(32)) subtract_select(.select(ctrl_ALUopcode[0]), .in0(data_operandB), .in1(not_data_operandB), .out(CLA_B));

    //add/sub (overflow is calculated)
    bit32_cla adder(.data_operandA(data_operandA), .data_operandB(CLA_B), .data_cin(ctrl_ALUopcode[0]), .sum(sum), .overflow(overflow));

    //left shift
    left_barrel_shifter sll(.data_operandA(data_operandA), .ctrl_shiftamt(ctrl_shiftamt), .data_result(left_shift_out));

    //right shifter
    right_barrel_shifter sra(.data_operandA(data_operandA), .ctrl_shiftamt(ctrl_shiftamt), .data_result(right_shift_out));

    //and
    bit32_and ander(.data_operandA(data_operandA), .data_operandB(data_operandB), .data_result(and_out));

    //or
    bit32_or orer(.data_operandA(data_operandA), .data_operandB(data_operandB), .data_result(or_out));

    //isNotEqual
    //should use 32 bit comparator
    or NotEqual(isNotEqual, sum[0], sum[1], sum[2], sum[3], sum[4], sum[5], sum[6], sum[7], sum[8], sum[9], sum[10], sum[11], sum[12], sum[13], sum[14], sum[15], sum[16], sum[17], sum[18], sum[19], sum[20], sum[21], sum[22], sum[23], sum[24], sum[25], sum[26], sum[27], sum[28], sum[29], sum[30], sum[31]);
    // comp_32 EQ_and_GT(.EQ1(1'b1), .GT1(1'b0), .A(data_operandA), .B(data_operandB), .EQ0(EQ0), .GT0(GT0));
    // not NotEqual(isNotEqual, EQ0);

    //isLessThan
    // should use 32 bit comparator
    not not_msb(not_sum_msb, sum[31]);
    mux_2  #(.WIDTH(1)) less_than(.select(overflow), .in0(sum[31]), .in1(not_sum_msb), .out(isLessThan));
    
    // not NotGreaterThan(not_greater_than, GT0);
    // nor is_less_than(isLessThan, EQ0, GT0);

    //final output
    mux_8 final_result(.select(ctrl_ALUopcode[2:0]), .in0(sum), .in1(sum), .in2(and_out), .in3(or_out), .in4(left_shift_out), .in5(right_shift_out), .in6(32'b0), .in7(32'b0), .out(data_result));
    

endmodule
