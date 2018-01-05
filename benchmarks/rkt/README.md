rkt
===

Simple benchmarks for space-efficient contracts.

## TODO 2017-12-14

- get Chaperones paper benchmarks (or, the modern version of such benchmarks)
  - render the reference, run DrRacket, ....
- try calibrating the inputs to the current benchmarks
  - as small as possible
  - systematic, large/small
- button to "run all" quickly
  - just a sampling of fast + slow configurations
  - later we'll go back and run-all or sample


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


## Results

Some interesting stats, see `output-2017-04-04/` for raw data.

```
+-----------------+----------+-----------+
| Benchmark       | CONTRACT | MAX-DEPTH |
+-----------------+----------+-----------+
| acquire         |     hash |        10 |
| dungeon         | arr mvec |         2 |
| forth-bad       |      arr |         1 |
| forth-worst     |      arr |        42 |
| fsm-bad         |     ivec |     +3000 |
| fsm-worst       |     ivec |     +3000 |
| fsmoo-bad       |   m/ivec |         3 |
| fsmoo-worst     |   m/ivec |         3 |
| gregor          | arr ivec |         2 |
| lnm             |   arr-ho |         2 |
| mbta            |   arr-ho |         2 |
| morsecode       |          |           |
| quadBG          |     ivec |        24 |
| quadMB-bad      |          |           |
| quadMB-worst    |     ivec |        24 |
| snake           |          |           |
| synth           |     ivec |         8 |
| synth-worst     | arr ivec |      3 13 |
| suffixtree      |          |           |
| take5           |          |           |
| tetris          |          |           |
| trie            | struct-dc|       199 |
| zombie          |   arr-ho |        67 |
| zordoz          |   arr-ho |         2 |
+-----------------+----------+-----------+
```
