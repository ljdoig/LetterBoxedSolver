open Core

type t = { mutable is_leaf : bool; children : t option array }
[@@deriving fields]

let empty () = { is_leaf = false; children = Array.init 26 ~f:(fun _ -> None) }
let char_to_index c = Char.to_int c - 97
let index_to_char i = Char.of_int (97 + i) |> Option.value_exn

let insert t entry =
  let entry = String.lowercase entry |> String.to_list in
  let rec insert' t = function
    | [] -> t.is_leaf <- true
    | c :: cs ->
        let child =
          let i = char_to_index c in
          match Array.get t.children i with
          | Some child -> child
          | None ->
              let child = empty () in
              Array.set t.children i (Some child);
              child
        in
        insert' child cs
  in
  insert' t entry

let create entries =
  let t = empty () in
  List.iter entries ~f:(insert t);
  t

let contains t entry =
  let entry = String.lowercase entry |> String.to_list in
  let rec contains' t = function
    | [] -> t.is_leaf
    | c :: cs -> (
        let i = char_to_index c in
        match Array.get t.children i with
        | Some child -> contains' child cs
        | None -> false)
  in
  contains' t entry

let child t c = Array.get t.children (char_to_index c)

let to_list t =
  let all = Queue.create () in
  let rec search_tree prefix = function
    | None -> ()
    | Some t ->
        if t.is_leaf then
          List.rev prefix |> String.of_char_list |> Queue.enqueue all;
        Array.iteri t.children ~f:(fun i child ->
            search_tree (index_to_char i :: prefix) child)
  in
  search_tree [] (Some t);
  Queue.to_list all

let sexp_of_t t = to_list t |> List.sexp_of_t String.sexp_of_t
