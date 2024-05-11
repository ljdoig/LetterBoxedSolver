open Core

type t

val create : string list -> t
val contains : t -> string -> bool
val child : t -> char -> t option
val to_list : t -> string list
val sexp_of_t : t -> Sexp.t
