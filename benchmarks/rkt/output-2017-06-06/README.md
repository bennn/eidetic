Data comparing racket-contract to Racket 6.9

Script that generated the numbers:

```
RACO=raco6.9
RACKET=racket6.9
RACOC=raco-contract
RACKETC=racket-contract
ITERS=20
for BM in acquire-worst array dungeon-worst forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst plot quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
  cd ${BM};
  find . -name "compiled" | xargs rm -r; ${RACO} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RACKET} main.rkt >> ${RACKET}.txt; done;
  find . -name "compiled" | xargs rm -r; ${RACOC} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RACKETC} main.rkt >> ${RACKETC}.txt; done;
  cd ..;
done;
```

Script that generated table + graph:

```
#lang racket/base
(require plot/no-gui plot/utils file/glob racket/path math/statistics racket/format)

(define RC.txt "racket-contract.txt")
(define R69.txt "racket6.9.txt")
(define OUT "output-2017-06-06")

(define (datas)
  (for/list ((rkt6.9 (in-glob (build-path "*" R69.txt))))
    (define bm-name
      (let-values ([(base name mb) (split-path rkt6.9)])
        (let-values (((b2 n2 mb2) (split-path base)))
          (path->string n2))))
    (define rktrc (build-path (current-directory) bm-name RC.txt))
    (define data6.9 (file->data rkt6.9))
    (define data-rc (file->data rktrc))
    (copy-file rkt6.9 (build-path OUT (format "~a-6.9.txt" bm-name)))
    (copy-file rktrc (build-path OUT (format "~a-r-c.txt" bm-name)))
    (list bm-name data6.9 data-rc)))

(define (file->data fn)
  (with-input-from-file fn
    (lambda ()
      (for/list ((ln (in-lines)))
        (parse-time ln "cpu")))))

(define (parse-time str [kind "cpu"])
  (define rx (regexp (format "~a time: ([0-9]+) " kind)))
  (define m (regexp-match rx str))
  (if m
    (string->number (cadr m))
    (raise-user-error 'parse-time str)))

(define (rnd n)
  (~r n #:precision '(= 2)))

(define (print-table)
  (displayln "| benchmark | racket 6.9 (ms) | racket-contract (ms) |")
  (for ((d (in-list (datas))))
    (define name (car d))
    (define d69 (cadr d))
    (define drc (caddr d))
    (when (and (not (null? d69)) (not (null? drc)))
      (printf "| ~a | ~a | ~a |~n" name (rnd (mean d69)) (rnd (mean drc))))))

(define (print-graph)
  (parameterize ((plot-font-size 7))
    (plot-file
      (discrete-histogram
        #:skip 10
        (for/list ([d (in-list (datas))] #:when (and (not (null? (cadr d))) (not (null? (caddr d)))))
          (vector (car d) (/ (mean (caddr d)) (mean (cadr d))))))
      "out.png"
      'png
      #:title "Overhead of racket-contract vs. Racket 6.9"
      #:y-max 11
      #:width 2000
      #:x-label "Benchmark"
      #:y-label "Slowdown factor (e.g. 2 means '2x slower')")))
```
