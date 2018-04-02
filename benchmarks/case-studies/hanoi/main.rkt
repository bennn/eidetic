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

;;(time (main 16 3))

#;(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main 16 3)) (collect-garbage 'major))))
(time (main 16 3))
