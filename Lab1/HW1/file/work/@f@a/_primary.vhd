library verilog;
use verilog.vl_types.all;
entity FA is
    port(
        s               : out    vl_logic;
        carry_out       : out    vl_logic;
        x               : in     vl_logic;
        y               : in     vl_logic;
        carry_in        : in     vl_logic
    );
end FA;
