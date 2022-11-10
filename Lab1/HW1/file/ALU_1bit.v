`include "FA.v"
module ALU_1bit(result, c_out, set, overflow, a, b, less, Ainvert, Binvert, c_in, op);
input        a;
input        b;
input        less;
input        Ainvert;
input        Binvert;
input        c_in;
input  [1:0] op;
output       result;
output       c_out;
output       set;                 
output       overflow;

/*
	Write Your Design Here ~
*/

Mux2 first_mux2(.in1(a), .in2(!a), .sel(Ainvert), .result());
Mux2 second_mux2(.in1(b), .in2(!b), .sel(Binvert), .result());
FA full_adder(.x(first_mux2.result), .y(second_mux2.result), .carry_in(c_in), .s(), .carry_out());
Mux4 first_mux4(.in1(first_mux2.result & second_mux2.result), .in2(first_mux2.result | second_mux2.result), .in3(full_adder.s), .in4(less), .sel(op), .result());
assign result = first_mux4.result;
assign c_out = full_adder.carry_out;
assign set = full_adder.s;
assign overflow = c_in ^ full_adder.carry_out;

endmodule

module Mux2 (
    input in1 ,input in2, input sel, output result 
);

assign result = sel ? in2 : in1;
    
endmodule


module Mux4 (
    input in1 , input in2, input in3, input in4, input [1:0] sel, output result 
);

assign result = ( sel == 2'b00 ) ? in1 :
             	( sel == 2'b01 ) ? in2 :
             	( sel == 2'b10 ) ? in3 :
                                   in4 ;
    
endmodule