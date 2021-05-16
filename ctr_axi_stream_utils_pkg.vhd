library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.axi_stream_interface_pkg.all;

package axi_stream_utils_pkg is

    type axi_stream_interface_array_t is array (natural range <>) of axi_stream_interface_t;
    type axi_stream_req_array_t is array (natural range <>) of axi_stream_req_t;
    type axi_stream_ack_array_t is array (natural range <>) of axi_stream_ack_t;

    pure function new_axi_stream_interface( data_width       : natural;
                                            user_width       : natural := 1
    ) return axi_stream_interface_t;

    pure function new_axi_stream_ack( i : axi_stream_interface_cnf_t ) return axi_stream_ack_t;
    pure function new_axi_stream_req( i : axi_stream_interface_cnf_t ) return axi_stream_req_t;
    pure function new_axi_stream_interface( axis_cnf : axi_stream_interface_cnf_t ) return axi_stream_interface_t;

    pure function new_axi_stream_ack_array( i : axi_stream_interface_cnf_t; n : positive ) return axi_stream_ack_array_t;
    pure function new_axi_stream_req_array( i : axi_stream_interface_cnf_t; n : positive ) return axi_stream_req_array_t;


    pure function get_tdata_width(   i : axi_stream_interface_t ) return natural;
    pure function get_tkeep_width(   i : axi_stream_interface_t ) return natural;
    pure function get_tuser_width(   i : axi_stream_interface_t ) return natural;

    pure function get_tdata_width(   i : axi_stream_interface_cnf_t ) return natural;
    pure function get_tkeep_width(   i : axi_stream_interface_cnf_t ) return natural;
    pure function get_tuser_width(   i : axi_stream_interface_cnf_t ) return natural;

    pure function is_ready(          i : axi_stream_interface_t ) return boolean;
    pure function is_valid(          i : axi_stream_interface_t ) return boolean;
    pure function is_beat(           i : axi_stream_interface_t ) return boolean;
    pure function is_last_beat(      i : axi_stream_interface_t ) return boolean;

    pure function all_interfaces_ready ( ia : axi_stream_ack_array_t ) return boolean;
    pure function all_interfaces_valid ( ia : axi_stream_req_array_t ) return boolean;

end axi_stream_utils_pkg;

package body axi_stream_utils_pkg is

    pure function new_axi_stream_ack( i : axi_stream_interface_cnf_t ) return axi_stream_ack_t is
        variable axi_stream_ack_v : axi_stream_ack_t;
    begin
        axi_stream_ack_v.tready := '1';
        return axi_stream_ack_v;
    end;

    pure function new_axi_stream_req( i : axi_stream_interface_cnf_t ) return axi_stream_req_t is
        variable axi_stream_req_v : axi_stream_req_t(tdata(get_tdata_width(i)-1 downto 0),
                                                     tkeep(get_tkeep_width(i)-1 downto 0),
                                                     tuser(get_tuser_width(i)-1 downto 0));
    begin
        axi_stream_req_v.tvalid := '0';
        axi_stream_req_v.tdata  := (others => '0');
        axi_stream_req_v.tkeep  := (others => '1');
        axi_stream_req_v.tlast  := '0';
        axi_stream_req_v.tuser  := (others => '0');
        return axi_stream_req_v;
    end;

    pure function new_axi_stream_interface(
        data_width      : natural;
        user_width      : natural := 1
    ) return axi_stream_interface_t is
        variable axi_stream_interface_v : axi_stream_interface_t(r(tdata(data_width-1   downto 0),
                                                                   tkeep(data_width/8-1 downto 0),
                                                                   tuser(user_width-1   downto 0 )));
    begin
        axi_stream_interface_v.a.tready                         := '1';
        axi_stream_interface_v.r.tvalid                         := '0';
        axi_stream_interface_v.r.tdata(data_width-1 downto 0)   := (others => '0');
        axi_stream_interface_v.r.tkeep(data_width/8-1 downto 0) := (others => '1');
        axi_stream_interface_v.r.tlast                          := '0';
        axi_stream_interface_v.r.tuser(user_width-1 downto 0 )  := (others => '0');
        return axi_stream_interface_v;
    end;

    pure function new_axi_stream_interface( axis_cnf : axi_stream_interface_cnf_t ) return axi_stream_interface_t is
    begin
        return new_axi_stream_interface( data_width => axis_cnf.data_width,
                                         user_width => axis_cnf.user_width );
    end;

    pure function new_axi_stream_ack_array( i : axi_stream_interface_cnf_t; n : positive ) return axi_stream_ack_array_t is
        variable axi_stream_ack_array_v : axi_stream_ack_array_t(0 to n-1);
    begin
        for j in 0 to n-1 loop
            axi_stream_ack_array_v(j) := new_axi_stream_ack(i);
         end loop;
        return axi_stream_ack_array_v;
    end;

    pure function new_axi_stream_req_array( i : axi_stream_interface_cnf_t; n : positive ) return axi_stream_req_array_t is
        variable axi_stream_req_array_v : axi_stream_req_array_t(0 to n-1)(tdata(get_tdata_width(i)-1 downto 0),
                                                                           tkeep(get_tkeep_width(i)-1 downto 0),
                                                                           tuser(get_tuser_width(i)-1 downto 0));
    begin
        for j in 0 to n-1 loop
            axi_stream_req_array_v(j) := new_axi_stream_req(i);
         end loop;
        return axi_stream_req_array_v;
    end;

    pure function get_tdata_width( i : axi_stream_interface_t ) return natural is
    begin
        return get_tdata(i)'length;
    end function get_tdata_width;

    pure function get_tdata_width( i : axi_stream_interface_cnf_t ) return natural is
    begin
        return i.data_width;
    end function get_tdata_width;

    pure function get_tkeep_width( i : axi_stream_interface_t ) return natural is
    begin
        return get_tdata_width(i)/8;
    end function get_tkeep_width;

    pure function get_tkeep_width( i : axi_stream_interface_cnf_t ) return natural is
    begin
        return get_tdata_width(i)/8;
    end function get_tkeep_width;

    pure function get_tuser_width( i : axi_stream_interface_t ) return natural is
    begin
        return get_tuser(i)'length;
    end function get_tuser_width;

    pure function get_tuser_width( i : axi_stream_interface_cnf_t ) return natural is
    begin
        return i.user_width;
    end function get_tuser_width;

    pure function is_ready( i : axi_stream_interface_t ) return boolean is
    begin
    	return get_tready(i) = '1';
    end function is_ready;

    pure function is_valid( i : axi_stream_interface_t ) return boolean is
    begin
    	return get_tvalid(i) = '1';
    end function is_valid;

    pure function is_beat( i : axi_stream_interface_t ) return boolean is
    begin
    	return is_ready(i) and is_valid(i);
    end function is_beat;

    pure function is_last_beat( i : axi_stream_interface_t ) return boolean is
    begin
    	return is_beat(i) and get_tlast(i) = '1';
    end function is_last_beat;

    pure function all_interfaces_ready( ia : axi_stream_ack_array_t ) return boolean is
      variable all_interfaces_ready_v : boolean := true;
    begin
      all_interfaces_ready_v := true;
      loop_interfaces : for i in 0 to ia'length-1 loop
          all_interfaces_ready_v := all_interfaces_ready_v and ia(i).tready='1';
      end loop;
      return all_interfaces_ready_v;
    end function all_interfaces_ready;

    pure function all_interfaces_valid( ia : axi_stream_req_array_t ) return boolean is
      variable all_interfaces_valid_v : boolean := true;
    begin
      all_interfaces_valid_v := true;
      loop_interfaces : for i in 0 to ia'length-1 loop
          all_interfaces_valid_v := all_interfaces_valid_v and ia(i).tvalid='1';
      end loop;
      return all_interfaces_valid_v;
    end function all_interfaces_valid;

end axi_stream_utils_pkg;
