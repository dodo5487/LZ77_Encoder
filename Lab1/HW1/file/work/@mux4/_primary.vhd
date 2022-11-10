library verilog;
use verilog.vl_types.all;
entity Mux4 is
    port(
        in1             : in     vl_logic;
        in2             : in     vl_logic;
        in3             : in     vl_logic;
        in4             : in     vl_logic;
        sel             : in     vl_logic_vector(1 downto 0);
        result          : out    vl_logic
    );
end Mux4;
