library verilog;
use verilog.vl_types.all;
entity ALU_tb is
    generic(
        TEST_N_PAT_8bit : integer := 458752;
        TEST_L_PAT_8bit : integer := 20;
        GOLDEN_L_PAT_8bit: integer := 10;
        TEST_N_PAT_1bit : integer := 32;
        TEST_L_PAT_1bit : integer := 8;
        GOLDEN_L_PAT_1bit: integer := 4
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of TEST_N_PAT_8bit : constant is 1;
    attribute mti_svvh_generic_type of TEST_L_PAT_8bit : constant is 1;
    attribute mti_svvh_generic_type of GOLDEN_L_PAT_8bit : constant is 1;
    attribute mti_svvh_generic_type of TEST_N_PAT_1bit : constant is 1;
    attribute mti_svvh_generic_type of TEST_L_PAT_1bit : constant is 1;
    attribute mti_svvh_generic_type of GOLDEN_L_PAT_1bit : constant is 1;
end ALU_tb;
