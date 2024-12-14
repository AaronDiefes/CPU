module lshift_16bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[31:16] = data_operandA[15:0];
    assign data_result[15:0] = 16'b0;

endmodule