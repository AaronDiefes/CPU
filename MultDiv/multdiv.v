module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [31:0] mult_result;
    wire [31:0] div_result;

    wire mult_resultRDY;
    wire div_resultRDY;

    wire mult_data_exception;
    wire div_data_exception;

    wire multdiv_op;
    wire RDY_select;

    // add your code here

    //Need to make a register to store answers/other important data

    mult_32bit multiply(.data_operandA(data_operandA), .data_operandB(data_operandB), 
	.ctrl_MULT(ctrl_MULT), .clock(clock), 
	.data_result(mult_result), .data_exception(mult_data_exception), .data_resultRDY(mult_resultRDY));


    div_32bit divide(.data_operandA(data_operandA), .data_operandB(data_operandB), 
	.ctrl_DIV(ctrl_DIV), .clock(clock), 
	.data_result(div_result), .data_exception(div_data_exception), .data_resultRDY(div_resultRDY));

    mux_2 actual_data_result(.select(RDY_select), .in0(mult_result), .in1(div_result), .out(data_result));
    mux_2 #(.WIDTH(1)) true_data_exception(.select(RDY_select), .in0(mult_data_exception), .in1(div_data_exception), .out(data_exception));

    mux_2 #(.WIDTH(1)) operation_select(.select(ctrl_DIV), .in0(1'b0), .in1(1'b1), .out(multdiv_op));
    dffe_ref most_recent_op(.q(RDY_select), .d(multdiv_op), .clk(clock), .en(ctrl_MULT | ctrl_DIV), .clr(1'b0));

    mux_2 #(.WIDTH(1)) data_resultRDY_select(.select(RDY_select), .in0(mult_resultRDY), .in1(div_resultRDY), .out(data_resultRDY));

endmodule