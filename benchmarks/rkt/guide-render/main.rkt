#lang racket

(require (only-in scribble/render render))

(define (render-guide)
  ;; 1. Build
  (define doc (dynamic-require '"guide/guide.scrbl" 'doc))
  ;; 2. Render
  (void (render (list doc) (list "file") #:dest-dir "/tmp")))

;;(time (render-guide))

(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (render-guide)) (collect-garbage 'major))))
