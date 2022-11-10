library verilog;
use verilog.vl_types.all;
entity Counter is
    port(
        clk             : in     vl_logic;
        set             : in     vl_logic;
        stop            : in     vl_logic;
        jump            : in     vl_logic;
        reset           : in     vl_logic;
        change          : in     vl_logic;
        cout            : out    vl_logic_vector(3 downto 0)
    );
end Counter;
