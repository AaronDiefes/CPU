module comp_8(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [7:0] A, B;
    output EQ0, GT0;

    wire first_eq, first_gt;
    wire second_eq, second_gt;
    wire third_eq, third_gt;

    comp_2 first2(.EQ1(EQ1), .GT1(GT1), .A(A[7:6]), .B(B[7:6]), .EQ0(first_eq), .GT0(first_gt));
    comp_2 second2(.EQ1(first_eq), .GT1(first_gt), .A(A[5:4]), .B(B[5:4]), .EQ0(second_eq), .GT0(second_gt));
    comp_2 third2(.EQ1(second_eq), .GT1(second_gt), .A(A[3:2]), .B(B[3:2]), .EQ0(third_eq), .GT0(third_gt));
    comp_2 fourth2(.EQ1(third_eq), .GT1(third_gt), .A(A[1:0]), .B(B[1:0]), .EQ0(EQ0), .GT0(GT0));

endmodule