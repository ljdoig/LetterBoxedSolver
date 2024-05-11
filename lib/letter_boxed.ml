open Core
module Trie = Trie

let successors groups =
  List.concat_mapi groups ~f:(fun i group ->
      List.map (String.to_list group) ~f:(fun c ->
          let successors =
            List.concat_mapi groups ~f:(fun j group ->
                if j = i then [] else String.to_list group)
          in
          (c, successors)))

let unique_letters words =
  List.concat words
  |> List.fold ~init:0 ~f:(fun acc c ->
         let i = Trie.char_to_index c in
         acc lor (1 lsl i))

let solve' trie successors max_len =
  let chars = Map.keys successors in
  let goal = unique_letters [ chars ] in
  let to_word l = List.rev l |> String.of_char_list in
  let sols = Queue.create () in
  let rec traverse c subtrie letters words curr_word =
    let curr_word = c :: curr_word in
    if Trie.is_leaf subtrie then (
      (* Check this word is actually useful *)
      let curr = unique_letters [ curr_word ] in
      let letters' = curr lor letters in
      let words = curr_word :: words in
      if letters' = goal then
        List.map words ~f:to_word |> List.rev |> Queue.enqueue sols
      else if letters <> letters' && List.length words < max_len then
        Trie.child trie c
        |> Option.iter ~f:(fun subtrie -> traverse c subtrie letters' words []))
    else
      Map.find_exn successors c
      |> List.iter ~f:(fun c ->
             let child = Trie.child subtrie c in
             Option.iter child ~f:(fun subtrie ->
                 traverse c subtrie letters words curr_word))
  in
  List.iter chars ~f:(fun c ->
      Trie.child trie c
      |> Option.iter ~f:(fun subtrie -> traverse c subtrie 0 [] []));
  let compare s1 s2 =
    match List.length s1 - List.length s2 with
    | 0 ->
        let num_chars = List.sum (module Int) ~f:String.length in
        num_chars s1 - num_chars s2
    | x -> x
  in
  Queue.to_list sols |> List.sort ~compare

let load_trie filename groups =
  let chars = List.concat_map groups ~f:String.to_list |> Char.Set.of_list in
  let words =
    In_channel.with_file filename ~f:In_channel.input_lines
    |> List.map ~f:String.lowercase
    |> List.filter ~f:(String.for_all ~f:(Set.mem chars))
  in
  (Trie.create words, List.length words)

let solve filename groups max_len =
  let groups = String.lowercase groups |> String.split ~on:' ' in

  let trie, num_words = load_trie filename groups in
  Printf.sprintf "Loaded dictionary and filtered to relevant words (%d words)"
    num_words
  |> print_endline;

  let solutions =
    let successors =
      match successors groups |> Char.Map.of_alist with
      | `Ok successors -> successors
      | `Duplicate_key char ->
          raise_s [%message "Duplicate letter in groups" (char : char)]
    in
    solve' trie successors max_len
  in
  match solutions with
  | [] ->
      Printf.sprintf "No solutions exist with %d words or fewer" max_len
      |> print_endline;
      print_endline "Consider increasing max solution size with -max flag"
  | best :: _ ->
      let print_sol s = String.concat ~sep:" " s |> print_endline in
      Printf.sprintf "Found %d solution(s) of max length %d:"
        (List.length solutions) max_len
      |> print_endline;
      List.iter solutions ~f:print_sol;
      print_endline "\nBest solution:";
      print_sol best
