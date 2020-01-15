library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.axi_stream_interface_pkg.all;

package axi_stream_utils_pkg is

    type axi_stream_interface_array_t is array (natural range <>) of axi_stream_interface_t;

    pure function new_axi_stream_interface( data_width       : natural;
                                            user_width       : natural := 1
    ) return axi_stream_interface_t;

    pure function new_axi_stream_interface( axis_cnf : axi_stream_interface_cnf_t ) return axi_stream_interface_t;

    pure function get_tdata_width(   i : axi_stream_interface_t ) return natural;
    pure function get_tuser_width(   i : axi_stream_interface_t ) return natural;
    pure function is_ready(          i : axi_stream_interface_t ) return boolean;
    pure function is_valid(          i : axi_stream_interface_t ) return boolean;
    pure function is_beat(           i : axi_stream_interface_t ) return boolean;
    pure function is_last_beat(      i : axi_stream_interface_t ) return boolean;

end axi_stream_utils_pkg;

package body axi_stream_utils_pkg is

    pure function new_axi_stream_interface(
        data_width      : natural;
        user_width      : natural := 1
    ) return axi_stream_interface_t is
        variable axi_stream_interface_t : axi_stream_interface_t( tdata(data_width-1   downto 0),
                                                                  tkeep(data_width/8-1 downto 0),
                                                                  tuser(user_width-1   downto 0 )); 
    begin 
        return axi_stream_interface_t;
    end;

    pure function new_axi_stream_interface( axis_cnf : axi_stream_interface_cnf_t ) return axi_stream_interface_t is 
    begin 
        return new_axi_stream_interface( data_width => axis_cnf.data_width,
                                         user_width => axis_cnf.user_width );
    end;

    pure function get_tdata_width( i : axi_stream_interface_t ) return positive is
    begin
        return i.tdata'length;
    end function get_tdata_width;

    pure function get_tuser_width( i : axi_stream_interface_t ) return positive is
    begin
        return i.tuser'length;
    end function get_tuser_width;

    pure function is_ready( i : axi_stream_interface_t ) return boolean is
    begin
    	return i.tready = '1';
    end function is_ready;

    pure function is_valid( i : axi_stream_interface_t ) return boolean is
    begin
    	return i.tvalid = '1';
    end function is_valid;

    pure function is_beat( i : axi_stream_interface_t ) return boolean is
    begin
    	return is_ready(i) and is_valid(i);
    end function is_beat;

    pure function is_last_beat( i : axi_stream_interface_t ) return boolean is
    begin
    	return is_beat(i) and i.tlast = '1';
    end function is_last_beat;

end axi_stream_utils_pkg;
