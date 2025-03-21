(* Define a mac_address type *)
type mac_address = MacAddress of string

(* Helper function to validate MAC address format *)
let is_valid_mac mac =
  let parts = String.split_on_char ':' mac in
  List.length parts = 6
  && List.for_all
       (fun part ->
         String.length part = 2
         && Str.string_match (Str.regexp "[0-9a-fA-F][0-9a-fA-F]") part 0)
       parts

(* Smart constructor to create a mac_address from bytes *)
let mac_of_bytes (bytes : string) : mac_address option =
  if String.length bytes <> 6 then None
  else
    let parts =
      List.init 6 (fun i -> Printf.sprintf "%02x" (Char.code bytes.[i]))
    in
    let mac = String.concat ":" parts in
    Some (MacAddress mac)

(* Convert a mac_address to its string representation *)
let mac_stringify (MacAddress mac) : string = mac

(* Convert a string representation into bytes *)
let bytes_of_mac (MacAddress mac) =
  match String.split_on_char ':' mac with
  | [ a; b; c; d; e; f ] ->
      Some
        (String.concat ""
           (List.map
              (fun hex ->
                Char.chr (int_of_string ("0x" ^ hex)) |> String.make 1)
              [ a; b; c; d; e; f ]))
  | _ -> None

(* Smart constructor to create a mac_address from a string *)
let mac_of_string (mac : string) : mac_address option =
  if is_valid_mac mac then Some (MacAddress mac) else None
