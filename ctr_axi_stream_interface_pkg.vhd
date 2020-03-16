library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package axi_stream_interface_pkg is

    type axi_stream_interface_cnf_t is record
        data_width : natural;
        user_width : natural;
    end record axi_stream_interface_cnf_t;
    constant AXIS_INTERFACE_CNF_ZERO_C : axi_stream_interface_cnf_t := axi_stream_interface_cnf_t'(
        data_width => 128,
        user_width => 1
    );

    type axi_stream_req_t is record
        tvalid : std_ulogic;
        tdata  : std_ulogic_vector;
        tkeep  : std_ulogic_vector;
        tlast  : std_ulogic;
        tuser  : std_ulogic_vector;
    end record axi_stream_req_t;

    type axi_stream_ack_t is record
        tready : std_ulogic;
    end record axi_stream_ack_t;

    type axi_stream_interface_t is record
        r : axi_stream_req_t;
        a : axi_stream_ack_t;
    end record axi_stream_interface_t;
    
    pure function get_tready(  i : axi_stream_interface_t ) return std_ulogic;
    pure function get_tvalid(  i : axi_stream_interface_t ) return std_ulogic;
    pure function get_tdata(   i : axi_stream_interface_t ) return std_ulogic_vector;
    pure function get_tkeep(   i : axi_stream_interface_t ) return std_ulogic_vector;
    pure function get_tlast(   i : axi_stream_interface_t ) return std_ulogic;
    pure function get_tuser(   i : axi_stream_interface_t ) return std_ulogic_vector;
    
end axi_stream_interface_pkg;

package body axi_stream_interface_pkg is

    pure function get_tready( i : axi_stream_interface_t ) return std_ulogic is
    begin
        return i.a.tready;
    end function get_tready;

    pure function get_tvalid( i : axi_stream_interface_t ) return std_ulogic is
    begin
        return i.r.tvalid;
    end function get_tvalid;

    pure function get_tdata( i : axi_stream_interface_t ) return std_ulogic_vector is
    begin
        return i.r.tdata;
    end function get_tdata;

    pure function get_tkeep( i : axi_stream_interface_t ) return std_ulogic_vector is
    begin
        return i.r.tkeep;
    end function get_tkeep;

    pure function get_tlast( i : axi_stream_interface_t ) return std_ulogic is
    begin
        return i.r.tlast;
    end function get_tlast;

    pure function get_tuser( i : axi_stream_interface_t ) return std_ulogic_vector is
    begin
        return i.r.tuser;
    end function get_tuser;

end axi_stream_interface_pkg;
