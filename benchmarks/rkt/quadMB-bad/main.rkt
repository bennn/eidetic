#lang racket/base

;; AKA quick-test.rkt

;; -----------------------------------------------------------------------------

(require
 require-typed-check
 (only-in racket/class new send)
(only-in "world.rkt"
  world:allow-hyphenated-last-word-in-paragraph
  world:quality-default
  world:draft-quality)
(only-in "quad-main.rkt"
  typeset)
(only-in "quick-sample.rkt"
  quick-sample)
(only-in "render.rkt"
  ;; TODO worried about this signature
  pdf-renderer%))

;; =============================================================================

(define (main)
  (parameterize ([world:quality-default world:draft-quality])
    (define to (typeset (quick-sample)))
    (send (new pdf-renderer%) render-to-file to "./output.pdf")
    (delete-file "./output.pdf")))

#;(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main)) (collect-garbage 'major))))
(time (main))
