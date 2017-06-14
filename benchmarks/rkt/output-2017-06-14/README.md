output-2017-06-14
===

Comparing racket-contract commit 4cc5e06c16f4d5e907d505ac00391d4c62870f69 with and without a patch.

Contents of this README:

1. the patch
2. script to generate data
3. script to collect data
4. script to plot data

Eventually these scripts should be library-form so I can stop copy-pasting

### 1. the patch

```
From fb7cf43a9513010f02c06b7c5991f3f12f4adc6f Mon Sep 17 00:00:00 2001
From: Daniel Feltey <dfeltey@gmail.com>
Date: Tue, 13 Jun 2017 14:52:38 -0500
Subject: [PATCH 1/1] Disbale checking at leaves

---
 racket/collects/racket/contract/private/arrow-space-efficient.rkt  | 2 +-
 racket/collects/racket/contract/private/vector-space-efficient.rkt | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/racket/collects/racket/contract/private/arrow-space-efficient.rkt b/racket/collects/racket/contract/private/arrow-space-efficient.rkt
index cd25a38..704c5e4 100644
--- a/racket/collects/racket/contract/private/arrow-space-efficient.rkt
+++ b/racket/collects/racket/contract/private/arrow-space-efficient.rkt
@@ -293,7 +293,7 @@
   (unless (multi/c? m/c)
     (error "internal error: not a space-efficient contract"))
   (cond [(multi-leaf/c? m/c)
-         (apply-proj-list (multi-leaf/c-proj-list m/c) val)]
+         val]
         ;; multi-> cases
         [(value-has-space-efficient-support? val m/c)
          (space-efficient-guard
diff --git a/racket/collects/racket/contract/private/vector-space-efficient.rkt b/racket/collects/racket/contract/private/vector-space-efficient.rkt
index 05ae8b2..83ced1c 100644
--- a/racket/collects/racket/contract/private/vector-space-efficient.rkt
+++ b/racket/collects/racket/contract/private/vector-space-efficient.rkt
@@ -187,7 +187,7 @@
     (error "internal error: not a space-efficient contract"))
   (cond
     [(multi-leaf/c? ctc)
-     (apply-proj-list (multi-leaf/c-proj-list ctc) val)]
+     val]
     [(value-has-vectorof-space-efficient-support? val chap-not-imp?)
      (do-first-order-checks ctc val)
      (vectorof-space-efficient-guard ctc val (multi-ho/c-latest-blame ctc) chap-not-imp?)]
@@ -453,7 +453,7 @@
     (error "internal error: not a space-efficient contract"))
   (cond
     [(multi-leaf/c? ctc)
-     (apply-proj-list (multi-leaf/c-proj-list ctc) val)]
+     val]
     [(value-has-vector/c-space-efficient-support? val chap-not-imp?)
      (do-vector/c-first-order-checks ctc val)
      (vector/c-space-efficient-guard ctc val (multi-ho/c-latest-blame ctc) chap-not-imp?)]
--
2.5.4 (Apple Git-61)
```

### 2. script to generate data

```
# E = experimental
# C = control
RACOE=raco-contract-no-proj-list
RACKETE=racket-contract-no-proj-list
RACOC=raco-contract
RACKETC=racket-contract
ITERS=20
for BM in acquire-worst array dungeon-worst forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst plot quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst; do
  cd ${BM};
  find . -name "compiled" | xargs rm -r; ${RACOE} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RACKETE} main.rkt >> ${RACKETE}.txt; done;
  find . -name "compiled" | xargs rm -r; ${RACOC} make -v main.rkt; for i in `seq 0 ${ITERS}`; do ${RACKETC} main.rkt >> ${RACKETC}.txt; done;
  cd ..;
done;
```

### 3. script to collect data

```
#lang racket/base

(define bm* (map symbol->string '(
  acquire-worst array dungeon-worst forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst plot quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie trie-vector zombie-worst zordoz-worst)))

(define RKT "racket-contract.txt")
(define NO-PROJ "racket-contract-no-proj-list.txt")
(define OUT "output-2017-06-14")

(for ((bm (in-list bm*)))
  (define rkt (build-path bm RKT))
  (define rnp (build-path bm NO-PROJ))
  (if (and (file-exists? rkt) (file-exists? rnp))
    (begin
      (copy-file rkt (build-path OUT (format "~a-rc.txt" bm)))
      (copy-file rnp (build-path OUT (format "~a-np.txt" bm))))
    (printf "WARNING: skipping ~a~n" bm)))
```

### 4. script to plot data

```
#lang racket/base
(require plot/no-gui plot/utils file/glob racket/path math/statistics racket/format)

(define bm* (map symbol->string '(
  acquire-worst array forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst fsm-worst-case graph gregor-worst jpeg kcfa-worst lnm-worst mbta-worst morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst suffixtree-worst synth synth-worst take5-worst tetris-worst trie-vector zombie-worst zordoz-worst)))

(define (datas)
  (for/list ((bm (in-list bm*)))
    (list bm (file->data (format "~a-rc.txt" bm)) (file->data (format "~a-np.txt" bm)))))

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
  (displayln "| benchmark | racket-contract (ms) | no-proj-list (ms) |")
  (for ((d (in-list (datas))))
    (define name (car d))
    (define d69 (cadr d))
    (define drc (caddr d))
    (when (and (not (null? d69)) (not (null? drc)))
      (printf "| ~a | ~a | ~a |~n" name (rnd (mean d69)) (rnd (mean drc))))))

(define (print-graph)
  (parameterize ((plot-font-size 7))
    (plot-file
      (list (hrule 1)
      (discrete-histogram
        #:skip 6
        (for/list ([d (in-list (datas))] #:when (and (not (null? (cadr d))) (not (null? (caddr d)))))
          (vector (car d) (/ (mean (caddr d)) (mean (cadr d)))))))
      "out.png"
      'png
      #:title "Overhead of no-proj-list vs. racket-contract"
      #:y-max 1.5
      #:width 2000
      #:x-label "Benchmark"
      #:y-label "Slowdown factor (e.g. 2 means '2x slower')")))

(with-output-to-file "TABLE.txt" #:exists 'replace print-table)
(print-graph)
```
