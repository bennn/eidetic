graph
===

From Stephen Chang's graph library:

- [https://github.com/stchang/graph](https://github.com/stchang/graph)

Notes:
- `graph-matrix.rkt` imports `math/array`
- the contract wrappers are due to immutable vectors


- - -

Some raw output

```
PLTSTDERR="error info@contract-wrapping" raco test main.rkt 2>&1 | sort | uniq -c                                                                                  ──(Wed,Apr19)─┘
111 contract-wrapping: arr-i 1
6125 contract-wrapping: arrow-higher-order 1
1465 contract-wrapping: arrow-higher-order 2
1460 contract-wrapping: arrow-higher-order 3
1458 contract-wrapping: arrow-higher-order 4
4798 contract-wrapping: box 1
801 contract-wrapping: box 2
799 contract-wrapping: box 3
798 contract-wrapping: box 4
18 contract-wrapping: case-arrow 1
687 contract-wrapping: immutable-vectorof-ho 1
691 contract-wrapping: immutable-vectorof-ho 2
664 contract-wrapping: immutable-vectorof-ho 3
6391 contract-wrapping: immutable-vectorof-ho 4
1735 contract-wrapping: immutable-vectorof-ho 5
1735 contract-wrapping: immutable-vectorof-ho 6
1734 contract-wrapping: immutable-vectorof-ho 7
3998 contract-wrapping: struct/dc 1
800 contract-wrapping: struct/dc 2
1 cpu time: 551 real time: 573 gc time: 24
1 raco test: "main.rkt"
```
