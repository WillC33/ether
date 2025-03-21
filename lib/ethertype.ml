type ethertype =
  | IPv4
  | IPv6
  | ARP
  | RRCP
  | Loopback
  | Unknown of int (* Catch-all for unknown EtherTypes *)

(* Function to convert two bytes to an EtherType *)
let ethertype_of_bytes bytes offset =
  let byte1 = Char.code bytes.[offset] in
  let byte2 = Char.code bytes.[offset + 1] in
  match (byte1 lsl 8) lor byte2 with
  | 0x0800 -> IPv4
  | 0x86DD -> IPv6
  | 0x0806 -> ARP
  | 0x8888 -> Loopback
  | 0x8899 -> RRCP
  | other -> Unknown other
