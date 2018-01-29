#lang racket/base
(require math/array)

(define (main)
  (let ((a (make-array #(9000) 0)))
    (array-andmap equal? a a)
    (array-ormap equal? a a)
    (void)))

(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main)) (collect-garbage 'major))))
