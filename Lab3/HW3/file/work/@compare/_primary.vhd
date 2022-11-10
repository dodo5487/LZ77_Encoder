library verilog;
use verilog.vl_types.all;
entity Compare is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        \signal\        : in     vl_logic_vector(1 downto 0);
        chardata        : in     vl_logic_vector(7 downto 0);
        nxt             : out    vl_logic_vector(7 downto 0);
        max_len         : out    vl_logic_vector(2 downto 0);
        tmp_offset      : out    vl_logic_vector(3 downto 0);
        max_offset      : out    vl_logic_vector(3 downto 0)
    );
end Compare;
