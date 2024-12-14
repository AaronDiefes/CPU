module comp_32(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [31:0] A, B;
    output EQ0, GT0;

    wire first_eq, first_gt;
    wire second_eq, second_gt;
    wire third_eq, third_gt;

    comp_8 first8(.EQ1(EQ1), .GT1(GT1), .A(A[31:24]), .B(B[31:24]), .EQ0(first_eq), .GT0(first_gt));
    comp_8 second8(.EQ1(first_eq), .GT1(first_gt), .A(A[23:16]), .B(B[23:16]), .EQ0(second_eq), .GT0(second_gt));
    comp_8 third8(.EQ1(second_eq), .GT1(second_gt), .A(A[15:8]), .B(B[15:8]), .EQ0(third_eq), .GT0(third_gt));
    comp_8 fourth8(.EQ1(third_eq), .GT1(third_gt), .A(A[7:0]), .B(B[7:0]), .EQ0(EQ0), .GT0(GT0));

endmodule