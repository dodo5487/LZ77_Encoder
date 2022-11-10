module LZ77_Decoder(clk,reset,code_pos,code_len,chardata,encode,finish,char_nxt);

input 				clk;
input 				reset;
input 		[3:0] 	code_pos;
input 		[2:0] 	code_len;
input 		[7:0] 	chardata;
output reg 			encode;
output reg 			finish;
output reg	[7:0] 	char_nxt;

reg [35:0] search_buffer;
reg [3:0] index;
wire [3:0] tmp_pos;
wire [2:0] tmp_len;
wire [3:0] tmp_result;

assign tmp_result = search_buffer[ (((tmp_pos + 1)*4)-1) -: 4 ];
assign tmp_pos = code_pos;
assign tmp_len = code_len;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		finish <= 0;
		encode <= 0;
		char_nxt <= 0;
		index <= 0;
		search_buffer <= 0;
	end
	else begin
		if (index == tmp_len) begin
			if (chardata == 8'h24) begin
				finish <= 1;
			end
			else begin
				search_buffer <= search_buffer << 4;
				search_buffer[3:0] <= chardata[3:0];
				char_nxt <= chardata[3:0];	
				index <= 0;
			end	
		end
		else begin
			search_buffer <= search_buffer << 4;
			search_buffer[3:0] <= tmp_result;
			char_nxt <= tmp_result;
			index <= index + 1;
		end
		
	end
end

endmodule