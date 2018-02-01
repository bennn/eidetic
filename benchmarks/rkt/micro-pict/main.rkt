#lang racket/base

(require racket/contract)

(define pict? integer?)

(define/contract (left p)
  (-> pict? pict?)
  p)

(define/contract (right p)
  (-> pict? pict?)
  p)

(define/contract (double f)
  (-> (-> pict? pict?) (-> pict? pict?))
  (lambda (x) (f (f x))))

(define p 0)

(define DUBS 22)

(define f*
  (for/fold ([left* left])
            ([i (in-range DUBS)])
    (double left*)))

(time (void (f* p)))
