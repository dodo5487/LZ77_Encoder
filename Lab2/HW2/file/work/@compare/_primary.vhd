library verilog;
use verilog.vl_types.all;
entity Compare is
    port(
        current_times   : in     vl_logic_vector(3 downto 0);
        set             : in     vl_logic;
        Gin             : in     vl_logic_vector(3 downto 0);
        Yin             : in     vl_logic_vector(3 downto 0);
        Rin             : in     vl_logic_vector(3 downto 0);
        GYR             : in     vl_logic_vector(2 downto 0);
        change          : out    vl_logic
    );
end Compare;
