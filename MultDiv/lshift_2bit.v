module lshift_2bit#(parameter WIDTH = 32)(data_operandA, data_result);
    input [31:0] data_operandA;
    output [31:0] data_result;

    assign data_result[31:2] = data_operandA[29:0];
    assign data_result[1:0] = 2'b0;

endmodule