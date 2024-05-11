open Core

type t

val create : string list -> t
val is_leaf : t -> bool
val char_to_index : char -> int
val index_to_char : int -> char
val contains : t -> string -> bool
val child : t -> char -> t option
val to_list : t -> string list
val sexp_of_t : t -> Sexp.t
