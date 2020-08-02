library verilog;
use verilog.vl_types.all;
entity crc_test is
    generic(
        gx_crc_8        : vl_logic_vector(0 to 5) := (Hi1, Hi1, Hi0, Hi1, Hi0, Hi1)
    );
    port(
        en              : in     vl_logic;
        data_in         : in     vl_logic_vector(9 downto 0);
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        crc_out         : out    vl_logic_vector(4 downto 0);
        data_out        : out    vl_logic_vector(14 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of gx_crc_8 : constant is 1;
end crc_test;
