library verilog;
use verilog.vl_types.all;
entity HA is
    port(
        s               : out    vl_logic;
        c               : out    vl_logic;
        x               : in     vl_logic;
        y               : in     vl_logic
    );
end HA;
