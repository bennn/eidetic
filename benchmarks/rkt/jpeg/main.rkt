#lang racket/base
(require "jpeg.rkt" racket/port)

(define (main test-file)
  (define j1 (read-jpeg test-file))
  (void
    (parameterize ([current-output-port (open-output-nowhere)])
      (write-jpeg (current-output-port) j1))))

(time (main "test.jpg"))
