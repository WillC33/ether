# Ether

Ether is a lightweight, educational Ethernet frame sniffer written in OCaml. It captures raw Ethernet frames from a network interface, parses MAC addresses and EtherTypes, and prints timestamped, human‑readable summaries to the terminal — 
This has been a perfect learning project for low‑level networking and OCaml’s FFI.

## Features

- **Native & Fast:** Compiled to native code via OCaml’s `ocamlopt` and Dune.
- **Raw Packet Capture:** Minimal C stubs for raw socket I/O on Linux (AF_PACKET)
- **Frame Parsing:** Extracts destination MAC, source MAC, EtherType, and payload length.
- **Colored Output:** Uses ANSITerminal for clear, timestamped packet summaries.
- **Minimal Dependencies:** Only OCaml standard library, Unix, and ANSITerminal.

## Prerequisites

- OCaml ≥ 4.12
- Dune ≥ 3.9
- Unix‑compatible OS (Linux recommended; macOS fallback available)
- Root privileges or CAP_NET_RAW to open raw sockets

## Installation

### Clone the repository

`git clone https://github.com/<your-username>/ether.git`
`cd ether`

### Build

Ether users dune as a build system
`dune build`

### Install

Can be installed with `dune install`

## Usage

Run Ether on a given network interface:

`ether <interface>`

Example:

Binding to the interface will require su permissions
`sudo ether eth0`

Terminate with Ctrl+C.

## Project Structure

```
ether/
├── bin/                # CLI entrypoint
│   ├── dune
│   └── main.ml
├── dune-project
├── ether.opam
├── lib/                # Core library modules
    ├── dune
    ├── ethertype.ml
    ├── frame.ml
    ├── mac.ml
    ├── parser.ml
    ├── payload.ml
    ├── printer.ml
    ├── sockets.ml
    └── sockets_stubs.c
```

## Contributing

Contributions welcome! Though this is really an educational project. Please open issues or pull requests. Before submitting:

- Run `dune fmt` to format code.

## License

BSD 3 Clause License — see `LICENSE` for details.

