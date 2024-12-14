module rshift_2bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[29:0] = data_operandA[31:2];
    assign data_result[31:30] = {2{data_operandA[31]}};

endmodule