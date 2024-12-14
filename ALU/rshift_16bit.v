module rshift_16bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[15:0] = data_operandA[31:16];
    assign data_result[31:16] = {16{data_operandA[31]}};

endmodule