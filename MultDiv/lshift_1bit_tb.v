module lshift_1bit_tb;
    reg [31:0] data_operandA;
    reg [4:0] ctrl_shiftamt;

    wire [31:0] data_result;

    lshift_1bit uut(.data_operandA(data_operandA), .ctrl_shiftamt(ctrl_shiftamt), .data_result(data_result));

    initial begin 
        ctrl_shiftamt = 5'd0;
        data_operandA = 32'd1;
        #10;
        $display("A:%b, Shiftamt:%b => Output:%b", data_operandA, ctrl_shiftamt, data_result);
        ctrl_shiftamt = 5'd1;
        #10;
        $display("A:%b, Shiftamt:%b => Output:%b", data_operandA, ctrl_shiftamt, data_result);
        $finish;

    end

endmodule