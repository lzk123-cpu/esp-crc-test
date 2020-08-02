library verilog;
use verilog.vl_types.all;
entity crc3 is
    generic(
        polynomial      : vl_logic_vector(0 to 16) := (Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        data            : in     vl_logic_vector(7 downto 0);
        rst_n           : in     vl_logic;
        crc             : out    vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of polynomial : constant is 1;
end crc3;
