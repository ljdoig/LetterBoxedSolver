open Core
module Trie = Trie

let solve ?(verbose = false) groups =
  Fn.ignore (verbose, groups);
  let words = In_channel.with_file "words.txt" ~f:In_channel.input_lines in
  let trie = Trie.create words in
  print_s [%message (List.length (Trie.to_list trie) : int)];
  print_s [%message (Trie.contains trie "apple" : bool)];
  print_s [%message (Trie.contains trie "to" : bool)];
  print_s [%message (Trie.contains trie "kevin" : bool)];
  print_s [%message (Trie.contains trie "disestablishmentarianism" : bool)]
