(lang dune 3.16)

(name ether)

(generate_opam_files true)

(source
 (github WillC33/ether))

(authors "William Cooke")

(maintainers "William Cooke")

(license BSD-3-Clause)

(documentation https://url/to/documentation)

(package
 (name ether)
 (synopsis "Ether is a basic parser for ethernet frames that operates over raw sockets via c bindings.")
 (description "Ether is a basic parser for ethernet frames that operates over raw sockets via c bindings. It is intended to be used as a learning tool for networking and understanding traffic.
              Written in OCaml, it is a simple project developed for my personal understanding of the network stack.")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
