combinations
===

Micro-benchmark for `ref`/`set` on a vector of functions.

- Adapted from a program that produced all combinations of size `K` from a list.
- Current program writes all combinations to a vector, specifically:
  + given a vector of functions and a buffer of size `K`
  + for each group of `K` functions in the vector
  + write the `K` functions to a buffer (overwriting the last write of `K` functions)
  + return `(void)`
