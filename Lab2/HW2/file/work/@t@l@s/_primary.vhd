library verilog;
use verilog.vl_types.all;
entity TLS is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        Set             : in     vl_logic;
        Stop            : in     vl_logic;
        Jump            : in     vl_logic;
        Gin             : in     vl_logic_vector(3 downto 0);
        Yin             : in     vl_logic_vector(3 downto 0);
        Rin             : in     vl_logic_vector(3 downto 0);
        Gout            : out    vl_logic;
        Yout            : out    vl_logic;
        Rout            : out    vl_logic
    );
end TLS;
