library verilog;
use verilog.vl_types.all;
entity Control is
    generic(
        inputstate      : vl_logic_vector(1 downto 0) := (Hi0, Hi0);
        countstate      : vl_logic_vector(1 downto 0) := (Hi0, Hi1);
        outputstate     : vl_logic_vector(1 downto 0) := (Hi1, Hi0);
        finishstate     : vl_logic_vector(1 downto 0) := (Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        chardata        : in     vl_logic_vector(7 downto 0);
        tmp_offset      : in     vl_logic_vector(3 downto 0);
        max_offset      : in     vl_logic_vector(3 downto 0);
        max_len         : in     vl_logic_vector(2 downto 0);
        nxt             : in     vl_logic_vector(7 downto 0);
        \signal\        : out    vl_logic_vector(1 downto 0);
        valid           : out    vl_logic;
        finish          : out    vl_logic;
        offset          : out    vl_logic_vector(3 downto 0);
        match_len       : out    vl_logic_vector(2 downto 0);
        char_nxt        : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of inputstate : constant is 2;
    attribute mti_svvh_generic_type of countstate : constant is 2;
    attribute mti_svvh_generic_type of outputstate : constant is 2;
    attribute mti_svvh_generic_type of finishstate : constant is 2;
end Control;
