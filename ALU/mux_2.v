module mux_2 #(parameter WIDTH = 32) (select, in0, in1, out);
    input select;
    input [WIDTH-1:0] in0;  
    input [WIDTH-1:0] in1; 
    output [WIDTH-1:0] out;
    assign out = select ? in1 : in0;  
endmodule
