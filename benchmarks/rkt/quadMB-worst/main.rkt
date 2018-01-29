#lang typed/racket/base

;; AKA quick-test.rkt

;; -----------------------------------------------------------------------------

(require
 require-typed-check
 "base/core-types.rkt"
 "base/quad-types.rkt"
 (only-in typed/racket/class new send)
)
(require/typed/check "world.rkt"
  [world:allow-hyphenated-last-word-in-paragraph Boolean]
  [world:quality-default (Parameterof Index)]
  [world:draft-quality Index])
(require/typed/check "quad-main.rkt"
  [typeset (-> Quad DocQuad)])
(require/typed/check "quick-sample.rkt"
  [quick-sample (-> Quad)])
(require/typed/check "render.rkt"
  [pdf-renderer%
    (Class
      [render-to-file (Quad Path-String -> Void)]
      [render-element (Quad -> Any)]
      [render-page ((Listof Quad) -> Void)]
      [render-word (Quad -> Any)]
      [render (-> Quad Any)]
      [finalize (-> Any Any)]
      [setup (-> Quad Quad)]
  )])

;; =============================================================================

(define (main)
  (parameterize ([world:quality-default world:draft-quality])
    (define to (typeset (quick-sample)))
    (send (new pdf-renderer%) render-to-file to "./output.pdf")
    (delete-file "./output.pdf")))

(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main)) (collect-garbage 'major))))
