# [Letter-boxed](https://www.nytimes.com/puzzles/letter-boxed) Solver

### Approach
Using a Trie and adjacency lists for subsequent letters, pick a starting letter then check the Trie to see if any of its subsequent letters are sub-Tries. Do this recursivley with the sub-Tries. If you get to a sub-Trie which represents the end of a word, begin a new word but continue traversing for longer words also. We cut the search at a max solution length of 3 words by default, as usually some solution exists with this length. See implementation [here](./lib/letter_boxed.ml).

### Run it
I've included a [MacOS executable](./letter_boxed.exe) which you can run with:
```
$ ./letter_boxed.exe "dko rjt snb auy"
```
which will print all 7759 solutions of max length 3. Or you can filter to shorter solutions:
```
$ ./letter_boxed.exe "dko rjt snb auy" -max 2
Loaded dictionary and filtered to relevant words (2006 words)
Found 2 solution(s) of max length 2:
junks storyboard
junks storyboards

Best solution:
junks storyboard
```
You can also pass your own word list if the [ENABLE](http://www.bananagrammer.com/2013/12/the-amazing-enable-word-list-project.html)
wordlist is not to your liking:
```
$ ./letter_boxed.exe "dko rjt snb auy" -max 2 -filename corpuses/scrabble.txt
Loaded dictionary and filtered to relevant words (3232 words)
Found 13 solution(s) of max length 2:
adjusts skyborn
juntos skyboard
juntas skyboard
jurants skyboard
junks storyboard
juntos skyboards
juntas skyboards
adjutants skyborn
adjustors skyborn
jurants skyboards
junks storyboards
adjutants skyboard
adjutants skyboards

Best solution:
adjusts skyborn
```
