module LZ77_Encoder(clk,reset,chardata,valid,encode,finish,offset,match_len,char_nxt);

input 				clk;
input 				reset;
input [7:0]		 	chardata;
output reg 			valid;
output reg			encode;
output reg			finish;
output reg [3:0]   	offset;
output reg [2:0] 	match_len;
output reg [7:0] 	char_nxt;

parameter [1:0] read_data = 0, caculate = 1 ,output_data = 2, finishing = 3;

// function cal;
//     input reg [71:0] search_buffer;
//     input reg [63:0] look_ahead_buffer; 
//     input reg [3:0] search_index;

//     reg [135:0] all;
//     reg [4:0] i,j;
//     reg [3:0] tmp_offset;
//     reg [2:0] tmp_match_len;
//     reg [7:0] tmp_char_nxt;
//     reg [3:0] final_offset;
//     reg [2:0] final_match_len;
//     reg [7:0] final_char_nxt;

//     begin
//         all = {search_buffer,look_ahead_buffer};
//         i = 0;
//         final_offset = 0;
//         final_match_len = 0;
//         final_char_nxt = 0;
//         while (i < 9) begin : pp
//             if (i == search_index) begin
//                 i = 9;
//                 disable;
//             end
//             tmp_match_len = 0;
//             tmp_offset = 0;
//             tmp_char_nxt = 0;
//             j = 0;
//             while (j < 8) begin : qq
//                 if (all[((71+i*8)-j*8) -: 8] == all[(63-j*8)-:8]) begin
//                     tmp_match_len = tmp_match_len + 1;
//                     tmp_offset = i;
//                     tmp_char_nxt = all[(55-j*8)-:8];
//                     if (tmp_match_len == 7) begin
//                         j = 8;
//                         disable qq;
//                     end
//                     j = j + 1;
//                 end
//                 else begin
//                     j = 8;
//                     disable qq;
//                 end
//             end
//             if (tmp_match_len >= final_match_len) begin
//                 final_match_len = tmp_match_len;
//                 final_offset = tmp_offset;
//                 final_char_nxt = tmp_char_nxt;
//             end 
//             i = i + 1;
//         end
//         if (final_match_len == 0) begin
//             offset = 0;
//             match_len = 0;
//             char_nxt = all[63 -: 8];
//         end
//         else begin
//             offset = final_offset;
//             match_len = final_match_len;
//             char_nxt = final_char_nxt;
//         end
//         cal = 0;
//     end
    
// endfunction

reg ok;
reg [4:0] i,j;
reg go_output;
reg [16391:0] input_sequence;
reg [71:0] search_buffer;
reg [63:0] look_ahead_buffer;
reg [3:0] look_index;
reg [3:0] search_index;
reg [1:0] curt_state;
reg [1:0] next_state;

wire [135:0] all;
reg [3:0] tmp_offset;
reg [2:0] tmp_match_len;
reg [7:0] tmp_char_nxt;
reg [3:0] final_offset;
reg [2:0] final_match_len;
reg [7:0] final_char_nxt;

assign all = {search_buffer,look_ahead_buffer};



always@(negedge clk or posedge reset) begin
    if(reset) begin
	    curt_state <= read_data;
	end
	else begin
	    curt_state <= next_state;
	end
end

always@(*) begin
    case(curt_state)
	    read_data: 
		    next_state = (look_index == 8) ? caculate : read_data;
        caculate:
            next_state = go_output? output_data : caculate;
		output_data: 
		    next_state = (char_nxt == 8'h24) ? finishing : read_data;
	endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        valid <= 0;
        finish <= 0;
        encode <= 1;
        offset <= 0;
        match_len <= 0;
        char_nxt <= 0;
		look_index <= 0;
        search_index <= 0;
        input_sequence <= 0;
        look_ahead_buffer <= 0;
        ok <= 0;
        go_output <= 0;
    end
    else begin
        case (curt_state)
            read_data : begin
                i <= 0;
                j <= 0;
                tmp_char_nxt <= 0;
                tmp_match_len <= 0;
                tmp_offset <= 0;
                final_char_nxt <= 0;
                final_match_len <= 0;
                final_offset <= 0;
                valid <= 0;
                if (chardata != 8'h24) begin
                    input_sequence <= input_sequence << 8;
                    input_sequence[7:0] <= chardata;
                    look_ahead_buffer <= look_ahead_buffer << 8;
                    look_ahead_buffer[7:0] <= input_sequence[16391:16384];
                    search_buffer <= search_buffer << 8;
                    search_buffer[7:0] <= look_ahead_buffer[63:56];
                end
                else begin
                    if (ok != 1) begin
                        input_sequence <= input_sequence << 8;
                        input_sequence[7:0] <= chardata;
                        look_ahead_buffer <= look_ahead_buffer << 8;
                        look_ahead_buffer[7:0] <= input_sequence[16391:16384];
                        search_buffer <= search_buffer << 8;
                        search_buffer[7:0] <= look_ahead_buffer[63:56];
                        ok <= 1;
                    end
                    else begin
                        input_sequence <= input_sequence << 8;
                        look_ahead_buffer <= look_ahead_buffer << 8;
                        look_ahead_buffer[7:0] <= input_sequence[16391:16384];
                        search_buffer <= search_buffer << 8;
                        search_buffer[7:0] <= look_ahead_buffer[63:56];
                        look_index <= look_index + 1;
                    end
                end   
            end
            caculate : begin
                valid <= 0;
                if (search_index == 0) begin
                    offset <= 0;
                    match_len <= 0;
                    char_nxt <= look_ahead_buffer[63:56];
                    go_output <= 1;               
                end
                else begin
                    if (i < search_index) begin
                        if (j < 7) begin
                            if (all[((71+i*8)-j*8) -: 8] == all[(63-j*8)-:8]) begin
                                tmp_match_len <= tmp_match_len + 1;
                                tmp_offset <= i;
                                tmp_char_nxt <= all[(55-j*8)-:8];
                                j <= j + 1;
                            end
                            else begin
                                if (tmp_match_len >= final_match_len) begin
                                    final_match_len <= tmp_match_len;
                                    final_offset <= tmp_offset;
                                    final_char_nxt <= tmp_char_nxt;
                                end
                                i <= i + 1;
                                j <= 0;
                                tmp_match_len <= 0;
                                tmp_offset <= 0;
                                tmp_char_nxt <= 0;
                            end
                        end
                        else begin
                            if (tmp_match_len >= final_match_len) begin
                                final_match_len <= tmp_match_len;
                                final_offset <= tmp_offset;
                                final_char_nxt <= tmp_char_nxt;
                            end
                            i <= i + 1;
                            j <= 0;
                        end
                    end
                    else begin
                        if (final_match_len == 0) begin
                            offset <= 0;
                            match_len <= 0;
                            char_nxt <= all[63 -: 8];
                            go_output <= 1;
                        end
                        else begin
                            offset <= final_offset;
                            match_len <= final_match_len;
                            char_nxt <= final_char_nxt;
                            go_output <= 1;
                        end
                    end
                end
            end
            output_data : begin
                go_output <= 0;
                valid <= 1;
                look_index <= look_index - (match_len + 1);
                search_index <= (search_index + (match_len + 1) >= 9) ? 9 : (search_index + (match_len + 1));
            end
            finishing : begin
                valid <= 0;
                finish <= 1;
            end
        endcase
    end
end


endmodule
