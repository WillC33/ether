/* sockets_stubs.c - Minimal socket stubs for OCaml (Linux & macOS)
 *
 */

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/alloc.h>   /* For mlsize_t and CAMLextern declarations */

/* Explicit declaration for caml_alloc_string */
CAMLextern value caml_alloc_string(mlsize_t len);

#include <sys/socket.h>

#ifdef __linux__
  #include <arpa/inet.h>
  #include <linux/if_packet.h>
  #include <net/ethernet.h>
  #define MY_AF_PACKET AF_PACKET
  #define MY_ETH_P_ALL ETH_P_ALL
#else
  /* On macOS/BSD, these headers aren't available, so we use a fallback raw socket */
  #include <netinet/in.h>
  #include <netinet/ip.h>
  #include <net/if_dl.h>
  #define MY_AF_PACKET AF_INET
  #define MY_ETH_P_ALL IPPROTO_RAW
#endif

#include <net/if.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

#ifndef UNIX_BUFFER_SIZE
#define UNIX_BUFFER_SIZE 65536
#endif

/**
 * caml_socket_open : string -> int
 * Open a socket on the given interface name.
 * v_ifname: the interface name
 */
#ifdef __linux__
CAMLprim value caml_socket_open(value v_ifname) {
  CAMLparam1(v_ifname);

  int fd = socket(MY_AF_PACKET, SOCK_RAW, htons(MY_ETH_P_ALL));
  
  if (fd < 0) caml_failwith(strerror(errno));
  
  struct sockaddr_ll sll;
  memset(&sll, 0, sizeof(sll));
  
  sll.sll_family = MY_AF_PACKET;
  sll.sll_protocol = htons(MY_ETH_P_ALL);
  sll.sll_ifindex = if_nametoindex(String_val(v_ifname));
  
  if (sll.sll_ifindex == 0) caml_failwith(strerror(errno));
  
  if (bind(fd, (struct sockaddr *)&sll, sizeof(sll)) < 0)
    caml_failwith(strerror(errno));
  CAMLreturn(Val_int(fd));
}
#else
CAMLprim value caml_socket_open(value v_ifname) {
  CAMLparam1(v_ifname);
  
  int fd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
  
  if (fd < 0) caml_failwith(strerror(errno));
  CAMLreturn(Val_int(fd));
}
#endif


/**
 * caml_socket_read : int -> int -> string
 * Read a packet from the socket.
 * v_fd: the file descriptor
 * v_bufsize: the buffer size
 */
CAMLprim value caml_socket_read(value v_fd, value v_bufsize) {
  CAMLparam2(v_fd, v_bufsize);
  CAMLlocal1(v_str);
  
  int fd = Int_val(v_fd);
  int len = Int_val(v_bufsize);
  v_str = caml_alloc_string(len);
  
  /* Explicitly cast away constness from String_val */
  ssize_t n = read(fd, (void *)String_val(v_str), len);
  
  if (n < 0) caml_failwith(strerror(errno));
  CAMLreturn(v_str);
}

/**
 * caml_socket_send : int -> string -> unit
 * Send a packet to the socket.
 * v_fd: the file descriptor
 * v_pkt: the packet
 */
CAMLprim value caml_socket_send(value v_fd, value v_pkt) {
  CAMLparam2(v_fd, v_pkt);
  
  int fd = Int_val(v_fd);
  ssize_t n = write(fd, String_val(v_pkt), caml_string_length(v_pkt));
  
  if (n < 0) caml_failwith(strerror(errno));
  CAMLreturn(Val_unit);
}

/**
 * caml_socket_close : int -> unit
 * Close the socket.
 * v_fd: the file descriptor
 */
CAMLprim value caml_socket_close(value v_fd) {
  CAMLparam1(v_fd);
  
  close(Int_val(v_fd));
  CAMLreturn(Val_unit);
}

