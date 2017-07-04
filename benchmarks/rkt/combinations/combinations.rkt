#lang racket/base

(require racket/contract (only-in racket/math natural?))

(provide
  (contract-out
    (combinations
     (-> (vectorof (-> natural? natural?))
         natural?
         (vectorof (-> natural? natural?))
         void?))))

(define (combinations v k dst)
  (define N (vector-length v))
  (define N-1 (- N 1))
  (define (vector-set/bits v b)
    (let ([dst-index (box 0)])
      (for ([i (in-range N-1 -1 -1)]
            #:when (bitwise-bit-set? b i))
        (vector-set! dst (unbox dst-index) (vector-ref v i))
        (set-box! dst-index (+ 1 (unbox dst-index))))))
  (define-values (first last incr)
    (let* ([first (- (expt 2 k) 1)]
           [gospers-hack ;; https://en.wikipedia.org/wiki/Combinatorial_number_system#Applications
            (if (zero? first)
              add1
              (lambda (n)
                (let* ([u (bitwise-and n (- n))]
                       [v (+ u n)])
                  (+ v (arithmetic-shift (quotient (bitwise-xor v n) u) -2)))))])
    (values first (arithmetic-shift first (- N k)) gospers-hack)))
  (let loop ([i first])
    (if (<= i last)
      (begin
        (vector-set/bits v i)
        (loop (incr i)))
      (void))))
