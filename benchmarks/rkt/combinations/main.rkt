#lang racket/base

(require "combinations.rkt")

(define N 20)
(define K 7)

(define (main)
  (define dst (make-vector K add1))
  (combinations (build-vector N (λ (i) (λ (j) (+ i j)))) K dst)
  (void))

#;(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main)) (collect-garbage 'major))))
(time (main))
