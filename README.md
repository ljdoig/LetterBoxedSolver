# [Letter-boxed](https://www.nytimes.com/puzzles/letter-boxed) Solver

Using a Trie and an adjacency list for subsequent letters, pick a starting letter then check the Trie to see if any of its subsequent letters are sub-Tries. If you get to a sub-Trie which represents the end of a word, begin a new word but continue traversing for longer words also. We cut the search at a max solution length of 3 words by default, as usually some solution exists with this length. 
