module rshift_1bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[30:0] = data_operandA[31:1];
    assign data_result[31] = data_operandA[31];

endmodule