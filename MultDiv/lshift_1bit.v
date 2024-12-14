module lshift_1bit #(parameter WIDTH = 32) (data_operandA, data_result);
    input [WIDTH - 1:0] data_operandA;
    output [WIDTH - 1:0] data_result;

    assign data_result[WIDTH - 1:1] = data_operandA[WIDTH - 2:0];
    assign data_result[0] = 1'b0;

endmodule

