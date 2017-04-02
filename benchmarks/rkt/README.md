rkt
===

Simple benchmarks for space-efficient contracts.


## Overview

Each folder in this directory must contain:
- a file `main.rkt`
  - running `racket main.rkt` should perform a non-trivial computation
    and print the running time of the computation (as determined by the `time`
    macro from `racket/base`) to standard output.
- a file `README.md` describing the origin, author, and purpose of the benchmark

Each folder may also contain:
- other `.rkt` files (that `main.rkt` depends on)

## Purpose

Folders in this directory contain interesting Racket programs.
An external program will run these programs with and without space-efficient
 contracts enabled.
