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

let test_solve ~filename ~groups ~max_len ~solutions:expected =
  let solutions = solve ~filename ~groups ~max_len in
  if not (List.equal (List.equal String.equal) expected solutions) then (
    print_s
      [%message (solutions : string list list) (expected : string list list)];
    assert false)

let suite =
  "Letter boxed tests"
  >::: [
         ( "Trie test 1" >:: fun _ ->
           test_trie
             [ "apple"; "app"; "cat"; ""; "ca" ]
             [ "ap"; "appl"; "x"; "c" ] );
         ("Trie test 2" >:: fun _ -> test_trie [] [ "a" ]);
         ("Trie test 3" >:: fun _ -> test_trie [ "" ] [ "a" ]);
         ( "Solve test basic" >:: fun _ ->
           test_solve ~filename:"1.txt" ~groups:"a b c" ~max_len:3
             ~solutions:[ [ "abc" ] ] );
         ( "Solve test multiple sols" >:: fun _ ->
           test_solve ~filename:"2.txt" ~groups:"dko rjt snb auy" ~max_len:4
             ~solutions:
               [
                 [ "krona"; "adjust"; "toby" ];
                 [ "krona"; "adjust"; "turbary" ];
                 [ "krona"; "adjust"; "tyrant"; "toby" ];
                 [ "krona"; "adjust"; "tyrant"; "turbary" ];
               ] );
         ( "Solve test max_len 3" >:: fun _ ->
           test_solve ~filename:"2.txt" ~groups:"dko rjt snb auy" ~max_len:3
             ~solutions:
               [
                 [ "krona"; "adjust"; "toby" ]; [ "krona"; "adjust"; "turbary" ];
               ] );
       ]

let () =
  Sys_unix.chdir "../../../test/test_corpuses";
  run_test_tt_main suite
