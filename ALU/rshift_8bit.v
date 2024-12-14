module rshift_8bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[23:0] = data_operandA[31:8];
    assign data_result[31:24] = {8{data_operandA[31]}};

endmodule