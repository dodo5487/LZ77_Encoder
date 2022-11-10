library verilog;
use verilog.vl_types.all;
entity ELA is
    generic(
        read_data       : vl_logic_vector(1 downto 0) := (Hi0, Hi0);
        caculate        : vl_logic_vector(1 downto 0) := (Hi0, Hi1);
        write_data      : vl_logic_vector(1 downto 0) := (Hi1, Hi0);
        finishing       : vl_logic_vector(1 downto 0) := (Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        in_data         : in     vl_logic_vector(7 downto 0);
        data_rd         : in     vl_logic_vector(7 downto 0);
        req             : out    vl_logic;
        wen             : out    vl_logic;
        addr            : out    vl_logic_vector(9 downto 0);
        data_wr         : out    vl_logic_vector(7 downto 0);
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of read_data : constant is 2;
    attribute mti_svvh_generic_type of caculate : constant is 2;
    attribute mti_svvh_generic_type of write_data : constant is 2;
    attribute mti_svvh_generic_type of finishing : constant is 2;
end ELA;
