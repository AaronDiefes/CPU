module rshift_4bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[27:0] = data_operandA[31:4];
    assign data_result[31:28] = {4{data_operandA[31]}};

endmodule