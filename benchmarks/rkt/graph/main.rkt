#lang racket
(require "graph-matrix.rkt"
         "graph-fns-allpairs-shortestpaths.rkt")

(require rackunit)

;; -----------------------------------------------------------------------------

(define matrix25.1
  (mk-matrix-graph [[0 3 8 #f -4]
                    [#f 0 #f 1 7]
                    [#f 4 0 #f #f]
                    [2 #f -5 0 #f]
                    [#f #f #f 6 0]]))

(define matrix25.2
  (mk-matrix-graph [[0 3 8 #f -4 0 3 8 #f -4]
                    [#f 0 #f 1 7 #f 0 #f 1 7]
                    [#f 4 0 #f #f #f 4 0 #f #f]
                    [2 #f -5 0 #f 2 #f -5 0 #f]
                    [#f #f #f 6 0 #f #f #f 6 0]
                    [0 3 8 #f -4 0 3 8 #f -4]
                    [#f 0 #f 1 7 #f 0 #f 1 7]
                    [#f 4 0 #f #f #f 4 0 #f #f]
                    [2 #f -5 0 #f 2 #f -5 0 #f]
                    [#f #f #f 6 0 #f #f #f 6 0]]))

#;(define matrix25.4
  (mk-matrix-graph [[0 3 8 #f -4 0 3 8 #f -4 0 3 8 #f -4 0 3 8 #f -4]
                    [#f 0 #f 1 7 #f 0 #f 1 7 #f 0 #f 1 7 #f 0 #f 1 7]
                    [#f 4 0 #f #f #f 4 0 #f #f #f 4 0 #f #f #f 4 0 #f #f]
                    [2 #f -5 0 #f 2 #f -5 0 #f 2 #f -5 0 #f 2 #f -5 0 #f]
                    [#f #f #f 6 0 #f #f #f 6 0 #f #f #f 6 0 #f #f #f 6 0]
                    [0 3 8 #f -4 0 3 8 #f -4 0 3 8 #f -4 0 3 8 #f -4]
                    [#f 0 #f 1 7 #f 0 #f 1 7 #f 0 #f 1 7 #f 0 #f 1 7]
                    [#f 4 0 #f #f #f 4 0 #f #f #f 4 0 #f #f #f 4 0 #f #f]
                    [2 #f -5 0 #f 2 #f -5 0 #f 2 #f -5 0 #f 2 #f -5 0 #f]
                    [#f #f #f 6 0 #f #f #f 6 0 #f #f #f 6 0 #f #f #f 6 0]
                    [0 3 8 #f -4 0 3 8 #f -4 0 3 8 #f -4 0 3 8 #f -4]
                    [#f 0 #f 1 7 #f 0 #f 1 7 #f 0 #f 1 7 #f 0 #f 1 7]
                    [#f 4 0 #f #f #f 4 0 #f #f #f 4 0 #f #f #f 4 0 #f #f]
                    [2 #f -5 0 #f 2 #f -5 0 #f 2 #f -5 0 #f 2 #f -5 0 #f]
                    [#f #f #f 6 0 #f #f #f 6 0 #f #f #f 6 0 #f #f #f 6 0]
                    [0 3 8 #f -4 0 3 8 #f -4 0 3 8 #f -4 0 3 8 #f -4]
                    [#f 0 #f 1 7 #f 0 #f 1 7 #f 0 #f 1 7 #f 0 #f 1 7]
                    [#f 4 0 #f #f #f 4 0 #f #f #f 4 0 #f #f #f 4 0 #f #f]
                    [2 #f -5 0 #f 2 #f -5 0 #f 2 #f -5 0 #f 2 #f -5 0 #f]
                    [#f #f #f 6 0 #f #f #f 6 0 #f #f #f 6 0 #f #f #f 6 0] ]))

(define (main)
  (void
    (all-pairs-shortest-paths/slow matrix25.1)
    (all-pairs-shortest-paths/faster matrix25.1)
    (floyd-warshall matrix25.1)
    (all-pairs-shortest-paths/slow matrix25.2)
    (all-pairs-shortest-paths/faster matrix25.2)
    (floyd-warshall matrix25.2))
  (void))

(for ((LOOP (in-list '(1 10 100 500))))
  (collect-garbage 'major)
  (collect-garbage 'major)
  (collect-garbage 'major)
  (displayln LOOP)
  (time (begin (for ((_ (in-range LOOP))) (main)) (collect-garbage 'major))))

