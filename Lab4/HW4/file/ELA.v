`timescale 1ns/10ps

module ELA(clk, rst, in_data, data_rd, req, wen, addr, data_wr, done);

	input				clk;
	input				rst;
	input		[7:0]	in_data;
	input		[7:0]	data_rd;
	output reg			req;
	output reg			wen;
	output reg	[9:0]	addr;
	output reg	[7:0]	data_wr;
	output reg			done;


	parameter [1:0] read_data = 0, caculate = 1 ,write_data = 2, finishing = 3;	
	reg [1:0] curt_state;
	reg [1:0] next_state;
	reg [511:0] tmp;
	reg [255:0] cal;
	reg [5:0] index;
	reg [1:0] read_state_index;
	reg read_fin, cal_fin, write_fin;
	reg first_time;
	reg [1:0] round;
	reg [15:0] cal_val;
	reg [5:0] times;
	wire [7:0] D1, D2, D3;
	wire [15:0] min;


	assign D1 = (tmp[(index+2)*8-1-:8] >= tmp[(index)*8+255-:8]) ? tmp[(index+2)*8-1-:8]-tmp[(index)*8+255-:8]:tmp[(index)*8+255-:8]-tmp[(index+2)*8-1-:8];
	assign D2 = (tmp[(index+1)*8-1-:8] >= tmp[(index+1)*8+255-:8]) ? tmp[(index+1)*8-1-:8]-tmp[(index+1)*8+255-:8]:tmp[(index+1)*8+255-:8]-tmp[(index+1)*8-1-:8];
	assign D3 = (tmp[(index)*8-1-:8] >= tmp[(index+2)*8+255-:8]) ? tmp[(index)*8-1-:8]-tmp[(index+2)*8+255-:8]:tmp[(index+2)*8+255-:8]-tmp[(index)*8-1-:8];
	
	assign min = (read_state_index == 2) ? (D2 <= D3 && D2 <= D1) ? (tmp[(index+1)*8-1-:8] + tmp[(index+1)*8+255-:8]) >> 1 : 
	(D1 <= D3 && D1 <= D2) ? (tmp[(index+2)*8-1-:8] + tmp[(index)*8+255-:8]) >> 1 : (D3 <= D1 && D3 <= D2) ? 
	(tmp[(index)*8-1-:8] + tmp[(index+2)*8+255-:8]) >> 1 : 0 : (D2 <= D3 && D2 <= D1) ? (tmp[(index+1)*8-1-:8] + tmp[(index+1)*8+255-:8]) >> 1 : 
	(D3 <= D1 && D3 <= D2) ? (tmp[(index)*8-1-:8] + tmp[(index+2)*8+255-:8]) >> 1 : (D1 <= D3 && D1 <= D2) ? (tmp[(index+2)*8-1-:8] + tmp[(index)*8+255-:8]) >> 1 : 0;



	always@(*) begin
		case(curt_state)
			read_data: 
				next_state = (first_time && read_fin) ? 2 : (read_fin && round == 1) ? 2 : 0;
			caculate:
				next_state = cal_fin ? 2 : 1;
			write_data: 
				next_state = (first_time && write_fin) ? 0 : (write_fin && round == 2) ? 1 : (write_fin && round == 0) ? 0 : 2;
		endcase
	end


	always @(posedge clk or posedge rst) begin
		if (rst) begin
			req <= 0;
			wen <= 0;
			addr <= 0;
			data_wr <= 0;
			done <= 0;
			index <= 0;
			read_state_index <= 0;
			read_fin <= 0;
			cal_fin <= 0;
			write_fin <= 0;
			tmp <= 0;
			first_time <= 1;
			round <= 0;
			cal <= 0;
			cal_val <= 0;
			times <= 0;
		end
		else begin
			case (curt_state)
				read_data :  begin
					write_fin <= 0;
					if (index == 0) begin
						req <= 1;
						index <= index + 1;
					end
					else begin
						req <= 0;
						case (read_state_index)
							0 : begin
								if (index < 33) begin
									tmp[(index*8-1)-:8] <= in_data;
									index <= index + 1;
								end
								else begin
									index <= 0;
									read_fin <= 1;
									read_state_index <= 2;
								end
							end
							1 : begin
								if (index < 33) begin
									tmp[(index*8-1)-:8] <= in_data;
									index <= index + 1;
								end
								else begin
									index <= 0;
									read_fin <= 1;
									read_state_index <= 2;
									round <= round + 1;
								end
							end 
							2 : begin
								if (index < 33) begin
									tmp[256+(index*8-1)-:8] <= in_data;
									index <= index + 1;
								end
								else begin
									index <= 0;
									read_fin <= 1;
									read_state_index <= 1;
									round <= round + 1;
								end
							end
						endcase
					end
				end

				caculate : begin
					write_fin <= 0;
					if (index == 0) begin
						index <= index + 1;
						cal_val <= ((tmp[(index*8+263)-:8] + tmp[(index*8+7)-:8]) >> 1);
					end
					else if (index == 32) begin
						index <= index + 1;
						cal_val <= ((tmp[(index*8+255)-:8] + tmp[(index*8-1)-:8]) >> 1);
					end
					else if (index == 33) begin
						index <= 0;
						round <= round + 1;
						cal_fin <= 1;
						cal[(index*8-9)-:8] <= cal_val;
					end
					else begin
						index <= index + 1;
						cal[(index*8-1)-:8] <= cal_val; 
						cal_val <= min;
					end
				end

				write_data : begin
					wen <= 1;
					read_fin <= 0;
					cal_fin <= 0;
					if (round == 3) begin
						if (index == 0) begin
							index <= index + 1;
							data_wr <= cal[(index*8+7)-:8];
						end
						else begin
							if (index < 32) begin
								index <= index + 1;
								addr <= addr + 1 ;
								data_wr <= cal[(index*8+7)-:8];
							end
							else begin
								write_fin <= 1;
								index <= 0;
								wen <= 0;
								round <= round + 1;	
								addr <= addr + 65;
								times <= times + 1;					
								if (times == 14) begin
									done <= 1;
								end				
							end
						end
					end
					else begin
						case (read_state_index)
						1 : begin
							if (index == 0) begin
								index <= index + 1;
								data_wr <= tmp[(index*8+263)-:8];
							end
							else begin
								if (index < 32) begin
									index <= index + 1;
									addr <= addr + 1 ;
									data_wr <= tmp[(index*8+263)-:8];
								end
								else begin
									write_fin <= 1;
									index <= 0;
									wen <= 0;
									round <= round + 1;
									addr <= addr - 63;
								end
							end
						end 
						2 : begin
							if (index == 0) begin
								index <= index + 1;
								data_wr <= tmp[(index*8+7)-:8];
							end
							else begin
								if (index < 32) begin
									index <= index + 1;
									addr <= addr + 1 ;
									data_wr <= tmp[(index*8+7)-:8];
								end
								else begin
									write_fin <= 1;
									index <= 0;
									wen <= 0;
									if (!first_time) begin
										round <= round + 1;
										addr <= addr - 63;
									end
									else begin
										first_time <= 0;
										addr <= addr + 33;
									end
								end
							end
						end 
						endcase    
					end
				end

				finishing : begin
					done <= 1;
				end

			endcase
		end
	end

	always@(negedge clk or posedge rst) begin
		if(rst) begin
			curt_state <= read_data;
		end
		else begin
			curt_state <= next_state;
		end
	end


endmodule