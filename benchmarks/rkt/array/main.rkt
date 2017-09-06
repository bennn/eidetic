#lang racket/base
(require math/array)


(time (void
  (let ((a (make-array #(9000) 0)))
    (array-andmap equal? a a)
    (array-ormap equal? a a))))
