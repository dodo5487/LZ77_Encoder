module TLS(clk, reset, Set, Stop, Jump, Gin, Yin, Rin, Gout, Yout, Rout);
input           clk;
input           reset;
input           Set;
input           Stop;
input           Jump;
input     [3:0] Gin;
input     [3:0] Yin;
input     [3:0] Rin;
output          Gout;
output          Yout;
output          Rout;
wire change;

Traffic_Control controller
    (
        .clk(clk),
        .reset(reset),
        .set(Set),
        .stop(Stop),
        .jump(Jump),
        .change(change),
        .Green(Gout),
        .Yellow(Yout),
        .Red(Rout)
    );
    Datapath datapath
    (
        .clk(clk),
        .reset(reset),
        .set(Set),
        .stop(Stop),
        .jump(Jump),
        .Gin(Gin),
        .Yin(Yin),
        .Rin(Rin),
        .GYR({Gout,Yout,Rout}),
        .change(change)
    );

endmodule

// Counter 
module Counter(clk, set, stop, jump, reset, change, cout);
    input clk, reset, change, set, stop, jump;
    output reg [3:0] cout;

    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            cout <= 1;
        end
        else
        begin
            if(set)
            begin
                cout <= 1;
            end
            else
            begin
                if(stop)
                begin
                    cout <= cout;
                end
                else
                begin
                    if(jump)
                    begin
                        cout <= 1;
                    end
                    else
                    begin
                        if(change)
                        begin
                            cout <= 1;
                        end
                        else
                        begin
                            cout <= cout + 1;
                        end
                    end
                end
            end
                
        end
    end

endmodule

// Compare
module Compare(current_times, set, Gin, Yin, Rin, GYR, change);
    input [3:0] Gin;
    input [3:0] Yin;
    input [3:0] Rin;
    input set;
    input [2:0] GYR;
    input [3:0] current_times;
    output reg change;
    reg [3:0] G_times, Y_times, R_times;

    always @(*)
    begin
        if(set)
        begin
            G_times = Gin;
            Y_times = Yin;
            R_times = Rin;
        end
    
    end

    always @(*)
    begin
        case(GYR)
            3'b100:
            begin
                if(current_times == G_times)
                    change = 1;
                else
                    change = 0;
            end
            3'b010:
            begin
                if(current_times == Y_times)
                    change = 1;
                else
                    change = 0;
            end
	        3'b001:
            begin
                if(current_times == R_times)
                    change = 1;
                else
                    change = 0;
            end            
            default: 
                change = 1;
        endcase
    end
endmodule

// Datapath
module Datapath(clk, reset, set, stop, jump, Gin, Yin, Rin, GYR, change);
    input clk, reset, set, stop, jump;
    input [3:0] Gin;
    input [3:0] Yin;
    input [3:0] Rin;
    input [2:0] GYR;
    output change;
    wire [3:0] Current_times;
    // Module
    Compare compare
    (
        .current_times(Current_times),
        .set(set),
        .Gin(Gin),
        .Yin(Yin),
        .Rin(Rin),
        .GYR(GYR),
        .change(change)
    );
    Counter counter
    (
        .clk(clk),
        .set(set),
        .stop(stop),
        .jump(jump),
        .reset(reset),
        .change(change),
        .cout(Current_times)
    );
endmodule

// Controller 
module Traffic_Control (clk, reset, set, stop, jump, change, Green, Yellow, Red);
    input clk, reset, change, set, stop, jump;
    output Red, Green, Yellow;
    reg Red, Green, Yellow;
    reg [1:0] currentstate, nextstate;
    parameter [1:0] Green_Light = 0, Yellow_Light = 1, Red_Light = 2;
                    
    // State Register (Flip-Flops)
    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            currentstate <= Green_Light;
        end
        else
            if(set)
            begin
                currentstate <= Green_Light;
            end
            else
            begin
                if(stop)
                begin
                    currentstate <= currentstate;
                end
                else
                    begin
                    if(jump)
                        currentstate <= Red_Light;
                    else
                        currentstate <= nextstate;
                end
            end
    end
    // Next State Logic
    always @(*)
    begin
        case(currentstate)
            Green_Light:
            begin
                if(change)
                    nextstate = Yellow_Light;
                else
                    nextstate = Green_Light; 
            end
            Yellow_Light:
            begin
                if(change)
                    nextstate = Red_Light;
                else
                    nextstate = Yellow_Light; 
            end
            Red_Light:
            begin
                if(change)
                    nextstate = Green_Light;
                else
                    nextstate = Red_Light; 
            end  
            default: 
                nextstate = Green_Light;
        endcase
    end
    // Output Logic
    always @(currentstate)
    begin
        case(currentstate)
            Green_Light:
            begin
                Green = 1'b1;
                Yellow = 1'b0;
                Red = 1'b0;
            end
	        Yellow_Light:
            begin
                Green = 1'b0;
                Yellow = 1'b1;
                Red = 1'b0;
            end
            Red_Light:
            begin
                Green = 1'b0;
                Yellow = 1'b0;
                Red = 1'b1;
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

