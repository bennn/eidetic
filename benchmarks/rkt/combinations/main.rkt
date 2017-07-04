#lang racket/base

(require "combinations.rkt")

(define N 20)
(define K 7)

(define (main)
  (define dst (make-vector K add1))
  (combinations (build-vector N (λ (i) (λ (j) (+ i j)))) K dst)
  (void))

(time (main))
