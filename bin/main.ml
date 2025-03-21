open Unix
open ANSITerminal
open Ether.Sockets
open Ether.Frame
open Ether.Parser
open Ether.Printer

let () =
  let interface =
    match Sys.argv with
    | [| _; interface |] -> interface
    | _ ->
        prerr_endline "Usage: ether <interface>";
        exit 1
  in

  let file_descr =
    try
      let sock = socket_open interface in
      sock
    with Failure msg ->
      prerr_string [ red ] ("Error opening socket on " ^ interface ^ ": " ^ msg);
      exit 1
  in

  printf [ green ] "Opened socket on %s \nListening for Ethernet frames...\n"
    interface;

  let rec read_packets () =
    (* Read up to 1514 bytes (max Ethernet frame size) *)
    match
      try Some (socket_read file_descr 1514)
      with Failure msg ->
        prerr_string [ red ] ("Read error: " ^ msg);
        None
    with
    | Some frame -> (
        let ts = timestamp () in
        print_timestamp frame ts;
        match parse_frame frame with
        | Some f ->
            f |> string_of_frame |> print_string [];
            read_packets ()
        | None ->
            print_endline "Failed to parse frame";
            flush Stdlib.stdout;
            read_packets ())
    | None -> read_packets ()
  in

  read_packets ()
