library verilog;
use verilog.vl_types.all;
entity ALU_1bit is
    port(
        result          : out    vl_logic;
        c_out           : out    vl_logic;
        set             : out    vl_logic;
        overflow        : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        less            : in     vl_logic;
        Ainvert         : in     vl_logic;
        Binvert         : in     vl_logic;
        c_in            : in     vl_logic;
        op              : in     vl_logic_vector(1 downto 0)
    );
end ALU_1bit;
