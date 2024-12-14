module mult_32bit(data_operandA, data_operandB, ctrl_MULT, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [31:0] new_multiplicand, multiplicand;
    wire [31:0] left_shift_multiplicand;
    wire shift_or_not;
    wire [31:0] before_alu_multiplicand;

    wire do_nothing_or_not;
    wire [65:0] nothing_select;

    wire [65:0] ProdMult_In;
    wire [65:0] ProductMultiplier;

    wire [4:0] alu_op;
    wire [31:0] alu_out;
    wire alu_overflow;
    wire alu_out_of;

    //counter out
    wire [4:0] q;

    //data exception
    wire all_zero;
    wire all_ones;

    //test
    wire [31:0] top_32bits_of_prodreg;


    //multiplicand register initialization//
    mux_2 multiplicand_reset(.select(ctrl_MULT), .in0(multiplicand), .in1(data_operandA), .out(new_multiplicand));
    reg_Nbit #(.WIDTH(32)) multiplicand_reg(.readOut(multiplicand), .writeIn(new_multiplicand), .clock(clock), .resetn(1'b0), .writeEnable(1'b1));


    lshift_1bit shifted_multiplicand(.data_operandA(multiplicand), .data_result(left_shift_multiplicand));

    //multiplier register initialization
    mux_8 #(.WIDTH(1)) do_nothing_select(.select(ProductMultiplier[2:0]), .in0(1'b1), .in1(1'b0), .in2(1'b0), .in3(1'b0), .in4(1'b0), .in5(1'b0), .in6(1'b0), .in7(1'b1), .out(do_nothing_or_not));

    //deal with alu overflow
    mux_2 #(.WIDTH(1)) alu_overflow_or_not(.select(alu_overflow), .in0(alu_out[31]), .in1(!alu_out[31]), .out(alu_out_of));
    mux_2 #(.WIDTH(66)) multiplier_select(.select(do_nothing_or_not), .in0({{3{alu_out_of}}, alu_out[31:0], ProductMultiplier[32:2]}), .in1({{3{ProductMultiplier[65]}}, ProductMultiplier[64:2]}), .out(nothing_select));

    mux_2 #(
        .WIDTH(66)
    )multiplier_reset(
        .select(ctrl_MULT), .in0(nothing_select), .in1({33'b0, data_operandB, 1'b0}), .out(ProdMult_In)
    );
    
    //Product/Multiplier register
    reg_Nbit #(.WIDTH(66)) ProductMultiplier_reg(.readOut(ProductMultiplier), .writeIn(ProdMult_In), .clock(clock), .resetn(1'b0), .writeEnable(1'b1));

    //before ALU//
    //do I shift or not? (2*M or not)
    mux_8 #(.WIDTH(1)) shift_select(.select(ProductMultiplier[2:0]), .in0(1'b1), .in1(1'b1), .in2(1'b1), .in3(1'b0), .in4(1'b0), .in5(1'b1), .in6(1'b1), .in7(1'b1), .out(shift_or_not));
    mux_2 ShiftMultiplicand(.select(shift_or_not), .in0(left_shift_multiplicand), .in1(multiplicand), .out(before_alu_multiplicand));

    //is it adding or subtracting?
    mux_8 #(.WIDTH(5)) add_sub_select(.select(ProductMultiplier[2:0]), .in0(5'b00000), .in1(5'b00000), .in2(5'b00000), .in3(5'b00000), .in4(5'b00001), .in5(5'b00001), .in6(5'b00001), .in7(5'b00000), .out(alu_op));

    //ALU 
    alu PartialProductCalc(.data_operandA(ProductMultiplier[64:33]), .data_operandB(before_alu_multiplicand), .ctrl_ALUopcode(alu_op), .ctrl_shiftamt(5'b0), .data_result(alu_out), .isNotEqual(), .isLessThan(), .overflow(alu_overflow));

    //PRODUCT FINISHED

    //COUNTER
    counter_5bit eugene(.clk(clock), .en(1'b1), .clr(ctrl_MULT), .q(q));

    assign data_resultRDY = q[4];

    assign data_result = ProductMultiplier[32:1];
    //test
    assign top_32bits_of_prodreg = ProductMultiplier[64:33];
    
    // Data exception
    assign all_zero = !(|ProductMultiplier[65:32]);
    assign all_ones = &ProductMultiplier[65:32];

    xnor overflow(data_exception, all_zero, all_ones);
endmodule