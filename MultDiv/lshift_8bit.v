module lshift_8bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[31:8] = data_operandA[23:0];
    assign data_result[7:0] = 8'b0;

endmodule