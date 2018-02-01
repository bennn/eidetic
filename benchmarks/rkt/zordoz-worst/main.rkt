#lang typed/racket/base

(require require-typed-check)

(require/typed/check "zo-shell.rkt"
  [init (-> (Vectorof String) Void)])

;; Stress tests: search entire bytecode for the fairly-common branch struct
(define SELF-TEST '("base/zo-shell.zo" "base/zo-find.zo" "base/zo-string.zo" "base/zo-transition.zo"))
(define (self-test)
  (for ([b SELF-TEST]) (init (vector b "branch"))))

(define SMALL-TEST "base/hello-world.zo")
(define (small-test)
  (init (vector SMALL-TEST "branch")))

(define LARGE-TEST "base/streams.zo")
(define (large-test)
  (init (vector LARGE-TEST "branch")))

;; -----------------------------------------------------------------------------

(define-syntax-rule (main test)
  (with-output-to-file "/dev/null" test #:exists 'append))

;(time (main self-test)) ; 1330ms
;(time (main small-test)) ;
;(time (main large-test)) ;

;; 2018-01-30: originally (time (main self-test))
#;(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main self-test)) (collect-garbage 'major))))
(time (main self-test))
