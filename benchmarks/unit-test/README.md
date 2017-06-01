unit-tests
===

Contract-wrapping results from running some libraries unit test suites

- `contract-all.txt` : from `racket -W info@contract-wrapping -l tests/racket/contract/all`
  - max wraps : 6 (ivec)
  - other notes : 46 unique messages, over 60K total
- `plot.txt` : from `PLTSTDERR="error info@contract-wrapping" raco test -c plot/tests`
  - max wraps : 4 (case-arrow, arrow-higher-order)
  - other notes : 16 unique messages, over 120K total


Lots of other files from other packages. Interesting ones:
- (NO, doesn't seem interesting) frog, arrow-higher-order 3
  - building PRL blog also makes 3
  - can probably get the 3 into a small exaple?
  - but probably cannot get more than 3, not in interesting way
- (NO, wraps maybe in typed racket) extensible-functions, 2
- (YES) graph, immvec 7
- math, ivecho 13
- plot mvecho 3  arr 4
- retry ... where are these coming from?
