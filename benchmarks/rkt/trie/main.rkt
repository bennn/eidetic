#lang racket

(require pfds/trie)

(define ITERS 100)

(define (main)
  (for/fold ([t (trie '((0)))])
            ([i (in-range ITERS)])
    (bind (list i) i t))
  (void))

(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main)) (collect-garbage 'major))))
