`timescale 1 ns / 100 ps
module bit32_and_tb;
    wire [31:0] data_operandA, data_operandB;
    wire [31:0] data_result;

    wire [31:0] expected_result;

    bit32_and f(.data_operandA(data_operandA), .data_operandB(data_operandB), .data_result(data_result));

    integer i;
    assign {data_operandA, data_operandB} = i[31:0];

    assign expected_result = data_operandA && data_operandB;

    initial begin
        for (i = 0; i < 31; i++) begin
            #20;
            if((data_result == expected_result)) begin
                $display("A:%b, B:%b => C:%b", data_operandA, data_operandB, data_result);
            end else begin
                $display("A:%b, B:%b => C:%b, expected:%b", data_operandA, data_operandB, data_result, expected_result);
            end 
        end
        $finish;
    end
endmodule