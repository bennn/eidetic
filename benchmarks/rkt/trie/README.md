trie
===

BEWARE
 this program runs much faster on Racket v6.12 for some reason

 the current space-efficient implementation runs much slower because it is
 not based on Racket v6.12


History
---

Adapted from John Clements example on the Racket mailing list.
More calls to `bind` implies deeper `struct/dc` contracts.

Original message:

- https://groups.google.com/d/msg/racket-users/WBPCsdae5fs/J7CIOeV-CQAJ


Original code:

```
#lang racket

(require pfds/trie)

(define (rand-list)
  (for/list ([i (in-range 128)])
    (random 256)))

(define t (trie (list (rand-list))))
(define u (time (bind (rand-list) 0 t)))
```
