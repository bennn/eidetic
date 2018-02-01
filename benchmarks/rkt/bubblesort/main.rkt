#lang racket/base
(require "bubble-gen.rkt")

#;(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (run-bubble plain #t)) (collect-garbage 'major))))
(time (void (run-bubble plain #t)))
