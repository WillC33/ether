open Mac
open Ethertype
open Payload

(* Define Ethernet frame using a variant payload *)
type ethernet_frame = {
  dst_mac : mac_address;
  src_mac : mac_address;
  ethertype : ethertype;
  payload : payload;
}
