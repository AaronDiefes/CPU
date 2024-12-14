module lshift_1bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[31:1] = data_operandA[30:0];
    assign data_result[0] = 1'b0;

endmodule

