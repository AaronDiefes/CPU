module lshift_4bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[31:4] = data_operandA[27:0];
    assign data_result[3:0] = 4'b0;

endmodule