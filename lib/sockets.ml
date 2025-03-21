external socket_open : string -> Unix.file_descr = "caml_socket_open"
external socket_read : Unix.file_descr -> int -> string = "caml_socket_read"
external socket_send : Unix.file_descr -> bytes -> unit = "caml_socket_send"
external socket_close : Unix.file_descr -> unit = "caml_socket_close"
