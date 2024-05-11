open OUnit2
open Core
open Letter_boxed

let test_trie words non_words : unit =
  let trie = Trie.create words in
  let sorted_output = List.sort ~compare:String.compare (Trie.to_list trie) in
  let expected = List.dedup_and_sort words ~compare:String.compare in
  assert (List.equal String.equal sorted_output expected);
  assert (List.for_all ~f:(Trie.contains trie) words);
  assert (List.for_all ~f:(Fn.compose not (Trie.contains trie)) non_words)

let suite =
  "Sudoku Tests"
  >::: [
         ( "Trie test 1" >:: fun _ ->
           test_trie
             [ "apple"; "app"; "cat"; ""; "ca" ]
             [ "ap"; "appl"; "x"; "c" ] );
         ("Trie test 2" >:: fun _ -> test_trie [] [ "a" ]);
         ("Trie test 3" >:: fun _ -> test_trie [ "" ] [ "a" ]);
       ]

let () = run_test_tt_main suite
