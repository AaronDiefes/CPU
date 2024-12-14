module div_32bit(data_operandA, data_operandB, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    //divisor wire, can use for input of ALU
    wire [31:0] divisor;
    wire [31:0] new_divisor;

    wire [63:0] RemainderQuotient;
    wire [63:0] RemainderQuotient_In;

    wire [63:0] intermediate_rq_lshift;
    wire [63:0] rq_lshift;

    wire [4:0] alu_op;
    wire [31:0] alu_out;

    wire quotient0;

    wire [63:0] after_cycle_rq;

    //counter out
    wire [5:0] q;

    wire [31:0] last_rv_out;
    wire [31:0] final_remainder;

    wire [31:0] new_data_operandA;
    wire [31:0] new_data_operandB;

    wire [31:0] neg_operandA;
    wire [31:0] neg_operandB;

    wire neg_quotient;

    wire [31:0] pos_data_result;
    wire [31:0] neg_data_result;

    alu NegOperandA(.data_operandA(~data_operandA), .data_operandB(32'd1), .ctrl_ALUopcode(5'b0), .ctrl_shiftamt(5'b0), .data_result(neg_operandA), .isNotEqual(), .isLessThan(), .overflow());
    alu NegOperandB(.data_operandA(~data_operandB), .data_operandB(32'd1), .ctrl_ALUopcode(5'b0), .ctrl_shiftamt(5'b0), .data_result(neg_operandB), .isNotEqual(), .isLessThan(), .overflow());

    xor NegQuotient(neg_quotient, data_operandA[31], data_operandB[31]);

    assign new_data_operandA = data_operandA[31] ? neg_operandA : data_operandA;
    assign new_data_operandB = data_operandB[31] ? neg_operandB : data_operandB;



    //divisor initialization
    mux_2 divisor_reset(.select(ctrl_DIV), .in0(divisor), .in1(new_data_operandB), .out(new_divisor));
    reg_Nbit #(.WIDTH(32)) divisor_reg(.readOut(divisor), .writeIn(new_divisor), .clock(clock), .resetn(1'b0), .writeEnable(1'b1));

    //RemainderQuotient initialization
    mux_2 #(.WIDTH(64)) initialize_remainderquotient(.select(ctrl_DIV), .in0(after_cycle_rq), .in1({32'b0, new_data_operandA}), .out(RemainderQuotient_In));
    reg_64bit RemainderQuotientReg(.readOut(RemainderQuotient), .writeIn(RemainderQuotient_In), .clock(clock), .resetn(1'b0), .writeEnable(1'b1));

    // always need to left shift RQ by 1
    lshift_1bit #(.WIDTH(64)) rqshift(.data_operandA(RemainderQuotient), .data_result(intermediate_rq_lshift));

    mux_2 #(.WIDTH(5)) add_or_sub_divisor(.select(RemainderQuotient[63]), .in0(5'b00001), .in1(5'b00000), .out(alu_op));

    alu AddSubRV(.data_operandA(rq_lshift[63:32]), .data_operandB(divisor), .ctrl_ALUopcode(alu_op), .ctrl_shiftamt(5'b0), .data_result(alu_out), .isNotEqual(), .isLessThan(), .overflow());

    mux_2 #(.WIDTH(1)) Dividend0_Select(.select(alu_out[31]), .in0(1'b1), .in1(1'b0), .out(quotient0));

    assign rq_lshift = {intermediate_rq_lshift[63:1], quotient0};

    assign after_cycle_rq[63:32] = alu_out;
    assign after_cycle_rq[31:0] = rq_lshift[31:0];

    //COUNTER
    counter_6bit jeremiah(.clk(clock), .en(1'b1), .clr(ctrl_DIV), .q(q));

    // assign data_resultRDY = q[5] | data_exception;
    assign data_resultRDY = q[5] | data_exception;
    
    //last step : R = R+V if MSB = 1 and q[5] = 1
    mux_4 last_add_v(.select({RemainderQuotient[63], q[5]}), .in0(32'b0), .in1(32'b0), .in2(32'b0), .in3(divisor), .out(last_rv_out));

    alu LastAddSubRV(.data_operandA(RemainderQuotient[63:32]), .data_operandB(last_rv_out), .ctrl_ALUopcode(5'b00000), .ctrl_shiftamt(5'b00000), .data_result(final_remainder), .isNotEqual(), .isLessThan(), .overflow());

    // assign RemainderQuotient[63:32] = final_remainder;

    assign pos_data_result = (data_exception & 1'b1) ? 32'b0  : RemainderQuotient[31:0];
    
    alu NegOldDataResult(.data_operandA(~pos_data_result), .data_operandB(32'd1), .ctrl_ALUopcode(5'b0), .ctrl_shiftamt(5'b0), .data_result(neg_data_result), .isNotEqual(), .isLessThan(), .overflow());

    assign data_result = neg_quotient ? neg_data_result : pos_data_result;
    //data exception
    assign data_exception = ~(|data_operandB);


endmodule