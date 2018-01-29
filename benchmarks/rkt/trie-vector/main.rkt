#lang racket

(require "pfds-trie.rkt")

(define ITERS 100)
(define LOOPS 1000)

(define (main)
  (for ((_ (in-range LOOPS)))
    (for/fold ([t (trie '((0)))])
              ([i (in-range ITERS)])
      (bind (list i) i t)))
  (void))

(time (main))
