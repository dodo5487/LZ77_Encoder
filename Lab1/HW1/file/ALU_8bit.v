`include "ALU_1bit.v"

module ALU_8bit(result, zero, overflow, ALU_src1, ALU_src2, Ainvert, Binvert, op);
input  [7:0] ALU_src1;
input  [7:0] ALU_src2;
input        Ainvert;
input        Binvert;
input  [1:0] op;
output [7:0] result;
output       zero;
output       overflow;
wire 		comb;

/*
	Write Your Design Here ~
*/

ALU_1bit alu0(.a(ALU_src1[0]), .b(ALU_src2[0]), .less(comb), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(Binvert), .op(op), .result(), .c_out(), .set(), .overflow());
ALU_1bit alu1(.a(ALU_src1[1]), .b(ALU_src2[1]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(alu0.c_out), .op(op), .result(), .c_out(), .set(), .overflow());
ALU_1bit alu2(.a(ALU_src1[2]), .b(ALU_src2[2]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(alu1.c_out), .op(op), .result(), .c_out(), .set(), .overflow());
ALU_1bit alu3(.a(ALU_src1[3]), .b(ALU_src2[3]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(alu2.c_out), .op(op), .result(), .c_out(), .set(), .overflow());
ALU_1bit alu4(.a(ALU_src1[4]), .b(ALU_src2[4]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(alu3.c_out), .op(op), .result(), .c_out(), .set(), .overflow());
ALU_1bit alu5(.a(ALU_src1[5]), .b(ALU_src2[5]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(alu4.c_out), .op(op), .result(), .c_out(), .set(), .overflow());
ALU_1bit alu6(.a(ALU_src1[6]), .b(ALU_src2[6]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(alu5.c_out), .op(op), .result(), .c_out(), .set(), .overflow());
ALU_1bit alu7(.a(ALU_src1[7]), .b(ALU_src2[7]), .less(1'b0), .Ainvert(Ainvert), .Binvert(Binvert), .c_in(alu6.c_out), .op(op), .result(), .c_out(), .set(), .overflow());
assign comb = alu7.set ^ alu7.overflow;
assign result = {alu7.result,alu6.result,alu5.result,alu4.result,alu3.result,alu2.result,alu1.result,alu0.result};
assign zero = ~(alu0.result | alu1.result | alu2.result | alu3.result | alu4.result | alu5.result | alu6.result | alu7.result); 
assign overflow = alu7.overflow;
endmodule
