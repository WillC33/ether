open Mac
open Ethertype
open Payload
open Frame

let debug_bytes s =
  Printf.printf "Debug bytes: ";
  String.iter (fun c -> Printf.printf "%02x " (Char.code c)) s;
  Printf.printf "\n%!"

let parse_frame bytes =
  if String.length bytes < 14 then None
  else
    (* Extract MAC addresses from raw binary data *)
    let dst_mac = mac_of_bytes (String.sub bytes 0 6) in
    let src_mac = mac_of_bytes (String.sub bytes 6 6) in

    let ethertype = ethertype_of_bytes bytes 12 in

    let payload_data = String.sub bytes 14 (String.length bytes - 14) in
    let payload =
      match ethertype with
      | IPv4 -> IPv4Packet payload_data
      | IPv6 -> IPv6Packet payload_data
      | ARP -> ARPPacket payload_data
      | Loopback -> LoopbackPacket payload_data
      | RRCP -> RawData payload_data
      | Unknown _ -> RawData payload_data
    in

    match (dst_mac, src_mac) with
    | Some dst_mac, Some src_mac ->
        Some { dst_mac; src_mac; ethertype; payload }
    | _ -> None
