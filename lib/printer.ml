open ANSITerminal
open Mac
open Ethertype
open Payload
open Frame

let timestamp () =
  let tm = Unix.localtime (Unix.gettimeofday ()) in
  Printf.sprintf "%04d-%02d-%02d %02d:%02d:%02d" (tm.Unix.tm_year + 1900)
    (tm.Unix.tm_mon + 1) tm.Unix.tm_mday tm.Unix.tm_hour tm.Unix.tm_min
    tm.Unix.tm_sec

let print_timestamp frame ts =
  let len = String.length frame in
  printf [ white ] "[%s] " ts;
  printf [ magenta; Bold ] "%d bytes\n%!" len

let string_of_mac mac = mac_stringify mac

let string_of_ethertype ethertype =
  match ethertype with
  | IPv4 -> "IPv4"
  | IPv6 -> "IPv6"
  | ARP -> "ARP"
  | Loopback -> "Loopback"
  | RRCP -> "RRCP"
  | Unknown n -> Printf.sprintf "Unknown (%d)" n

let string_of_payload payload =
  match payload with
  | IPv4Packet data ->
      Printf.sprintf "IPv4 Packet (%d bytes)" (String.length data)
  | IPv6Packet data ->
      Printf.sprintf "IPv6 Packet (%d bytes)" (String.length data)
  | ARPPacket data ->
      Printf.sprintf "ARP Packet (%d bytes)" (String.length data)
  | LoopbackPacket data ->
      Printf.sprintf "Loopback Packet (%d bytes)" (String.length data)
  | RawData data -> Printf.sprintf "Raw Data (%d bytes)" (String.length data)

let string_of_frame frame =
  let dst_mac = frame.dst_mac |> mac_stringify in
  let src_mac = frame.src_mac |> mac_stringify in
  let ethertype = string_of_ethertype frame.ethertype in
  let payload = string_of_payload frame.payload in

  let output =
    ANSITerminal.sprintf [ Bold; cyan ] "Destination MAC: "
    ^ ANSITerminal.sprintf [ yellow ] "%s\n" dst_mac
    ^ ANSITerminal.sprintf [ Bold; cyan ] "Source MAC: "
    ^ ANSITerminal.sprintf [ yellow ] "%s\n" src_mac
    ^ ANSITerminal.sprintf [ Bold; cyan ] "EtherType: "
    ^ ANSITerminal.sprintf [ green ] "%s\n" ethertype
    ^ ANSITerminal.sprintf [ Bold; cyan ] "Payload: "
    ^ ANSITerminal.sprintf [ white ] "%s\n" payload
    ^ "\n"
  in

  Stdlib.flush Stdlib.stdout;
  output
