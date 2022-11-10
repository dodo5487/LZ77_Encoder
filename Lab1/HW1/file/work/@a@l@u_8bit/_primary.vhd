library verilog;
use verilog.vl_types.all;
entity ALU_8bit is
    port(
        result          : out    vl_logic_vector(7 downto 0);
        zero            : out    vl_logic;
        overflow        : out    vl_logic;
        ALU_src1        : in     vl_logic_vector(7 downto 0);
        ALU_src2        : in     vl_logic_vector(7 downto 0);
        Ainvert         : in     vl_logic;
        Binvert         : in     vl_logic;
        op              : in     vl_logic_vector(1 downto 0)
    );
end ALU_8bit;
