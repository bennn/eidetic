#lang racket/base

(require
  "board.rkt"
  "solver.rkt"
  racket/class)

(define (main d p)
  (define S (new hanoi-solver% [num-disks d] [num-pegs p]))
  ;(display (send S format))
  (send S move-tower!)
  ;(display (send S format))
  (void))

(time (main 16 3))
