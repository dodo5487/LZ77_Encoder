library verilog;
use verilog.vl_types.all;
entity Traffic_Control is
    generic(
        Green_Light     : vl_logic_vector(1 downto 0) := (Hi0, Hi0);
        Yellow_Light    : vl_logic_vector(1 downto 0) := (Hi0, Hi1);
        Red_Light       : vl_logic_vector(1 downto 0) := (Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        set             : in     vl_logic;
        stop            : in     vl_logic;
        jump            : in     vl_logic;
        change          : in     vl_logic;
        Green           : out    vl_logic;
        Yellow          : out    vl_logic;
        Red             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Green_Light : constant is 2;
    attribute mti_svvh_generic_type of Yellow_Light : constant is 2;
    attribute mti_svvh_generic_type of Red_Light : constant is 2;
end Traffic_Control;
