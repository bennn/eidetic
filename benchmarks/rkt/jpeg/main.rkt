#lang racket/base
(require "jpeg.rkt" (only-in racket/file file->bytes))

(define (main bytes)
  (define outb (open-output-bytes))
  (define j1 (read-jpeg bytes))
  (void
    (rgb->jpeg (jpeg->rgb j1))
    (let-values (((_a _b _c) (jpeg-dimensions-and-exif j1))) (void))
    (write-jpeg outb j1)
    (close-output-port outb)))

(define bytes (file->bytes "test.jpg"))

(time (main bytes))
