# Sublime Dart syntax

The only sublime-syntax for Dart going around is a transformed version of the [grammar they publish](https://github.com/dart-lang/dart-syntax-highlight/blob/master/grammars/dart.json) for Visual Studio Code. I tried them and found them quite bad. Unfortunately I am terrible at thinking like a pushdown automaton so I sicced GPT-4.5 on xhigh on it.

## Installing

I have no plans of publishing to Package Control. There are already packages offering syntaxes for it [1](https://github.com/guillermooo/dart-sublime-bundle) [2](https://github.com/elMuso/Dartlight) and broader support. If you run into it and want to use it, be my guest. If you want to fork and submit to PC your fork, the LICENSE is permissive enough for that (and then some).

## Endorsements

- For the tests I have done, it seems to do a better job than the alternative.
- People that have authored proper syntaxes themselves commented "I've definitely seen worse"

## How?

I created https://github.com/guille/sublime-syntax-test-yaml/ for helping, more context in the README there. Most of the "harness" is in that repository with barely any changes.

On top of that I added the [plaintext grammar published by the Dart team](https://github.com/dart-lang/language/blob/main/tools/plaintext_grammar.dart) as context. The rest was a couple of feedback rounds.
