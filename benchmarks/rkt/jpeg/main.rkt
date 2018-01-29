#lang racket/base
(require "jpeg.rkt" racket/port)

(define (main test-file)
  (define j1 (read-jpeg test-file))
  (void
    (parameterize ([current-output-port (open-output-nowhere)])
      (write-jpeg (current-output-port) j1))))

;;(time (main "test.jpg"))

(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main "test.jpg")) (collect-garbage 'major))))
