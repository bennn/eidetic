#lang racket/base

(require (only-in "eval.rkt"
  forth-eval*
))

;; =============================================================================

(define (main)
  (call-with-input-file* "base/history-large.txt"
    (lambda (p)
      (let-values ([(_e _s) (forth-eval* p)]) (void))))
  (void))

#;(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main)) (collect-garbage 'major))))
(time (main))
