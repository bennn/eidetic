Overview
===

For the past few months, we've been measuring 32 benchmarks.
Eight (8) are based on small Racket programs or packages that had interesting
 contract-wrapping last spring.
The other 25 are gradually typed programs from the `gradual-typing-performance`
 repo.

Recently, I revived some benchmarks from the "Chaperones and Impersonators"
 paper.
We don't have data for these yet, but can get some data this week.

And yesterday I remembered a slow program from the mailing list.
This program seems to enter space-efficient mode (for arrows).


Details
---

About the columns,

`SOURCE` describes where the benchmark came from:

- `rkt` : based on a program from the package server or the main distribution
- `usr` : based on a program from the racket-users mailing list
- `gtp` : from the `nuprl/gradual-typing-performance` repo
- `chp` : from the "Chaperones and Impersonators" paper
- `   ` : from me, I wrote this program to test space-efficient contracts

`DATA` is one of:

- `NN.N` : the running time in SECONDS from Jan 26th
- `+inf` :  the running time from Jan 26th is very high because of
            space-inefficient contracts
- `    ` : we don't have data for this program, but it's ready to run
- `  X ` : we don't have data and CANNOT get data right now


| NAME             | SOURCE | DATA | DESCR
|------------------+--------+------+---
| array            |    rkt |   .2 | Calls `array-map` from `math/array`
| determinance     |    usr |      | `https://groups.google.com/forum/#!msg/racket-users/oo_FQqGVdcI/leUnIAn7yqwJ`
| graph            |    rkt |   .2 | Unit tests from the `graph` library, depends on `math/array`
| jpeg             |    rkt |  0.8 | Unit tests from `https://github.com/wingo/racket-jpeg`
| plot             |    rkt |      | Unit tests from the `plot` library
| trie             |    usr |      | `https://groups.google.com/forum/#!msg/racket-users/WBPCsdae5fs/J7CIOeV-CQAJ`
| trie-vector      |    usr |   .0 | Uses a vector instead of a struct for the `trie` datatype
| combinations     |        |  3.8 | Writes functions to a vector
| hanoi            |        | 12.7 | Writes functions to a vector
|------------------+--------+------+---
| acquire-worst    |    gtp |  1.5 | Board game
| dungeon-worst    |    gtp |  2.1 | Maze generator
| forth-bad        |    gtp |  2.8 | Forth interpreter
| forth-worst      |    gtp | 20.8 | ""
| fsm-bad          |    gtp | +inf | Economy simulator
| fsm-worst-case   |    gtp | +inf | ""
| fsmoo-bad        |    gtp | +inf | ""
| fsmoo-worst      |    gtp | +inf | ""
| gregor-worst     |    gtp |  1.1 | Time/data unit tests
| kcfa-worst       |    gtp |      | k-CFA, <http://matt.might.net/articles/implementation-of-kcfa-and-0cfa/>
| lnm-worst        |    gtp |   .7 | Makes plot
| mbta-worst       |    gtp |  3.3 | Graph algorithms
| morsecode-worst  |    gtp |  0.9 | String / hashtable operations
| quadBG-worst     |    gtp | 12.1 | Typesetting (with simple datatypes)
| quadMB-bad       |    gtp |   .9 | Typesetting (with recursive datatypes)
| quadMB-worst     |    gtp |  7.8 | ""
| snake-worst      |    gtp | 10.0 | HTDP game
| suffixtree-worst |    gtp |  9.3 | Longest-common-subsequence
| synth-bad        |    gtp |  5.7 | Data -> Music
| synth-worst      |    gtp | 14.0 | ""
| take5-worst      |    gtp |  3.6 | HDTP game
| tetris-worst     |    gtp |  8.2 | Board game
| zombie-worst     |    gtp |  1.7 | HTDP game with functions-as-objects
| zordoz-worst     |    gtp |  2.6 | Bytecode parser
|------------------+--------+------+---
| bubblesort       |    chp |      | Sorts a vector of integers
| guide-render     |    chp |      | Build & render Racket guide (Jan 2018)
| science          |    chp |      | "Evolves" an ordinary differential equation
| slideshow        |    chp |      | Renders a slideshow to picts
| struct           |    chp |      | Accesses a chaperoned struct
| typecheck        |    chp |    X | Typechecks `new-metrics.rkt`
| koala            |    chp |    X | (Lazy contracts)
| keystrokes       |    chp |    X | Dr.Racket tool
