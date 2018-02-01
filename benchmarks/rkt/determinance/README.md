determinance
===

Logic / Relational programming.

This program runs extremely slower after 6.11 due to a fix in Typed Racket's
 `or/c` contracts.
Previous versions would optimize `(U Null X)` to `any/c` no matter what `X` was.
Version 6.12 does NOT, correctly, but doing so slows down this program.


History
---

Adapted from `https://github.com/michaelballantyne/typed-racket-performance`

The original program was part of some research about MiniKanren ... but I can't
figure out what. I don't even know what 'determinanace' means.
