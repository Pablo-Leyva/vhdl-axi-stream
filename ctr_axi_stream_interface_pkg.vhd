library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package axi_stream_interface_pkg is

    type axi_stream_interface_cnf_t is record
        data_width : natural;
        user_width : natural;
    end record axi_stream_interface_cnf_t;
    constant AXIS_INTERFACE_CNF_ZERO_C : axi_stream_interface_cnf_t := axi_stream_interface_cnf_t'(
        data_width => 64,
        user_width => 1
    );

    type axi_stream_interface_t is record
        tready : std_ulogic;
        tvalid : std_ulogic;
        tdata  : std_ulogic_vector;
        tkeep  : std_ulogic_vector;
        tlast  : std_ulogic;
        tuser  : std_ulogic_vector;
    end record axi_stream_interface_t;

end axi_stream_interface_pkg;

package body axi_stream_interface_pkg is

end axi_stream_interface_pkg;
