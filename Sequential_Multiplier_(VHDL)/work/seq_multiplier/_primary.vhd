library verilog;
use verilog.vl_types.all;
entity seq_multiplier is
    generic(
        N               : integer := 4
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        clk             : in     vl_logic;
        RST             : in     vl_logic;
        start           : in     vl_logic;
        m               : out    vl_logic_vector;
        r               : out    vl_logic_vector;
        busy            : out    vl_logic;
        valid           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
end seq_multiplier;
