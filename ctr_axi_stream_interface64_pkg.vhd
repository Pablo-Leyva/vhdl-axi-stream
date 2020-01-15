library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package axi_stream_interface_pkg is

    type axi_stream_interface_cnf_t is record
        AXIS_TDATA_WIDTH : positive;
        AXIS_TUSER_WIDTH : positive;
    end record axi_stream_interface_cnf_t;
    constant AXIS_CNF_64_C : axi_stream_interface_cnf_t := axi_stream_interface_cnf_t'(
        AXIS_TDATA_WIDTH => 64,
        AXIS_TUSER_WIDTH => 0
    );

    type axi_stream_interface_t is record
        tready : std_ulogic;
        tvalid : std_ulogic;
        tdata  : std_ulogic_vector(AXIS_CNF_64_C.AXIS_TDATA_WIDTH-1 downto 0);
        tkeep  : std_ulogic_vector(tdata'length/8-1 downto 0);
        tlast  : std_ulogic;
        tuser  : std_ulogic_vector(AXIS_CNF_64_C.AXIS_TUSER_WIDTH-1 downto 0);
    end record axi_stream_interface_t;
    constant AXIS_INTERFACE_ZERO_C : axi_stream_interface_t := axi_stream_interface_t'(
        tready => '0',
        tvalid => '0',
        tdata  => (others => '0'),
        tkeep  => (others => '1'),
        tlast  => '0',
        tuser  => (others => '0')
    );

end axi_stream_interface_pkg;

package body axi_stream_interface_pkg is

end axi_stream_interface_pkg;
