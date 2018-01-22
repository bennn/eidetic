#lang racket

(require (only-in scribble/render render))

(define (render-guide)
  ;; 1. Build
  (define doc (dynamic-require '"guide/guide.scrbl" 'doc))
  ;; 2. Render
  (void (render (list doc) (list "file") #:dest-dir "/tmp")))

(time (render-guide))
