library verilog;
use verilog.vl_types.all;
entity Datapath is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        set             : in     vl_logic;
        stop            : in     vl_logic;
        jump            : in     vl_logic;
        Gin             : in     vl_logic_vector(3 downto 0);
        Yin             : in     vl_logic_vector(3 downto 0);
        Rin             : in     vl_logic_vector(3 downto 0);
        GYR             : in     vl_logic_vector(2 downto 0);
        change          : out    vl_logic
    );
end Datapath;
