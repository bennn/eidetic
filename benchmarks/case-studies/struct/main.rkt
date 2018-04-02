#lang racket/base
(require (only-in racket/unsafe/ops
                  unsafe-struct-ref
                  unsafe-struct*-ref))

(struct fish (weight color) #:mutable)

(define N 100000000)

(define (loop f)
  (for ([i (in-range N)])
    (fish-weight f)))

(define (do-direct)
  (loop (fish 1 "blue")))

(define (do-impersonate)
  (loop (impersonate-struct (fish 1 "blue")
                            fish-weight (lambda (f v) v)
                            set-fish-weight! (lambda (f v) v))))

(define (do-chaperone)
  (loop (chaperone-struct (fish 1 "blue")
                          fish-weight (lambda (f v) v))))

(define (do-unsafe)
  (define (unsafe-loop f)
    (time
     (for ([i (in-range N)])
       (unsafe-struct-ref f 0))))
  (unsafe-loop (fish 1 "blue")))

(define (do-unsafe*)
  (define (unsafe*-loop f)
    (time
     (for ([i (in-range N)])
       (unsafe-struct*-ref f 0))))
  (unsafe*-loop (fish 1 "blue")))

(time
  (void (do-impersonate)
        (do-chaperone)))
