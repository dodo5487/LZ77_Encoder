// Counter
module Counter(clk, rst, Recount_Counter, Count_Out);
    input clk, rst, Recount_Counter;
    output [3:0] Count_Out;
    reg [3:0] Count_Out;
    always @(posedge clk)
    begin
        if(rst)
        begin
            Count_Out <= 0;
        end
        else
        begin
            if(Recount_Counter)
                Count_Out <= 0;
	        else
                Count_Out <= Count_Out + 1;
        end
    end
endmodule
// Comparator
module Compare(current_times, RGY, Recount_counter);
    input [2:0] RGY;
    input [3:0] current_times;
    output Recount_counter;
    reg Recount_counter;
    parameter R_times = 4, G_times = 2, Y_times = 0;

    always @(*)
    begin
        case(RGY)
            3'b100:
            begin
                if(current_times == R_times)
                    Recount_counter = 1;
                else
                    Recount_counter = 0;
            end
	        3'b001:
            begin
                if(current_times == Y_times)
                    Recount_counter = 1;
                else
                    Recount_counter = 0;
            end
            3'b010:
            begin
                if(current_times == G_times)
                    Recount_counter = 1;
                else
                    Recount_counter = 0;
            end
            default: 
                Recount_counter = 1;
        endcase
    end
endmodule
// Datapath
module Datapath(clk, rst, RGY, Recount);
    input clk, rst;
    input [2:0] RGY;
    output Recount;
    wire [3:0] Current_times;
    // Module
    Compare compare
    (
        .current_times(Current_times),
        .RGY(RGY),
        .Recount_counter(Recount)
    );
    Counter counter
    (
        .clk(clk),
        .rst(rst),
        .Recount_Counter(Recount),
        .Count_Out(Current_times)
    );
endmodule
// Contorller
module Traffic_Control (clk, rst, Recount_Counter, Red, Green, Yellow);
    input clk, rst, Recount_Counter;
    output Red, Green, Yellow;
    reg Red, Green, Yellow;
    reg [1:0] currentstate, nextstate;
    parameter [1:0] Red_Light = 0, Green_Light = 1, 
                    Yellow_Light = 2;
    // State Register (Flip-Flops)
    always @(posedge clk)
    begin
        if(rst)
            currentstate <= Red_Light;
        else
            currentstate <= nextstate;
    end
    // Next State Logic
    always @(*)
    begin
        case(currentstate)
            Red_Light:
            begin
                if(Recount_Counter)
                    nextstate = Green_Light;
                else
                    nextstate = Red_Light; 
            end
            Green_Light:
            begin
                if(Recount_Counter)
                    nextstate = Yellow_Light;
                else
                    nextstate = Green_Light; 
            end
	        Yellow_Light:
            begin
                if(Recount_Counter)
                    nextstate = Red_Light;
                else
                    nextstate = Yellow_Light; 
            end
            default: 
                nextstate = Red_Light;
        endcase
    end
    // Output Logic
    always @(currentstate)
    begin
        case(currentstate)
            Red_Light:
            begin
                Red = 1'b1;
                Green = 1'b0;
                Yellow = 1'b0;
            end
            Green_Light:
            begin
                Red = 1'b0;
                Green = 1'b1;
                Yellow = 1'b0;
            end
	        Yellow_Light:
            begin
                Red = 1'b0;
                Green = 1'b0;
                Yellow = 1'b1;
            end
            default:
            begin
                Red = 1'b0;
                Green = 1'b0;
                Yellow = 1'b0;
            end
        endcase
    end
endmodule
// Traffic Light
module TrafficLight(clk, rst, Red, Green, Yellow);
    input clk, rst;
    output Red, Green, Yellow;
    wire Recount_counter; 
    // Module
    Traffic_Control controller
    (
        .clk(clk),
        .rst(rst),
        .Recount_Counter(Recount_counter),
        .Red(Red),
        .Green(Green),
        .Yellow(Yellow)
    );
    Datapath datapath
    (
        .clk(clk),
        .rst(rst),
        .RGY({Red,Green,Yellow}),
        .Recount(Recount_counter)
    );
endmodule




