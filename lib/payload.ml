type payload =
  | IPv4Packet of string (* Placeholder for now *)
  | IPv6Packet of string (* Placeholder for now *)
  | ARPPacket of string (* Placeholder for now *)
  | LoopbackPacket of string (* Placeholder for now *)
  | RawData of string (* For unknown payloads *)
