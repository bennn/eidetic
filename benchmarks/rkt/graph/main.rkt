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

(define (main)
  (define matrix25.1res/slow (all-pairs-shortest-paths/slow matrix25.1))
  (define matrix25.1res/faster (all-pairs-shortest-paths/faster matrix25.1))
  (define matrix25.1res/floyd (floyd-warshall matrix25.1))
  (void))

(time (main))

