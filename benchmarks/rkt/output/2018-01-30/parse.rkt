#lang racket/base

;; Usage:
;;   `racket parse.rkt`

;; Prints data to STDOUT

;; -----------------------------------------------------------------------------

;; Parse output from 2018-01-30,
;;  the data from running benchmarks over multiple loops

;; Data contains:
;; - benchmark name
;;   - version : (or/c "6.12" "master")
;;     - LOOP : natural?
;;       - time* (listof natural? natural? natural?)

(require
  racket/pretty
  racket/string
  racket/list
  racket/file
  racket/path
  file/glob)

(define OUTPUT "." #;(build-path "output" "2018-01-30"))
(define MASTER "master")
(define v612 "6.12")
(define PATTERN (format "*-~a.txt" MASTER))

(define (collect-all)
  (define H (make-hash))
  (for ((master-file (in-glob (build-path OUTPUT PATTERN))))
    (define n (file-name-from-path master-file))
    (define bm-name (filename->benchmark-name (path->string n)))
    (define v612-file (build-path OUTPUT (format "~a-~a.txt" bm-name v612)))
    (if (file-exists? v612-file)
      (hash-set! H bm-name
                 (make-immutable-hash
                   (list (cons MASTER (collect-file master-file))
                         (cons v612 (collect-file v612-file)))))
      (void
        (printf "WARNING no data for ~a~n" v612-file))))
  H)

(define (collect-file fname)
  ;; return hash from LOOP to times
  (define H (make-hash))
  (with-input-from-file fname
    (lambda ()
      (define current-key (box #f))
      (for ((ln (in-lines)))
        (define N (string->number ln))
        (if N
          (set-box! current-key N)
          (hash-update! H (unbox current-key)
                        (lambda (old) (cons (parse-time ln) old))
                        '())))))
  H)

(define parse-time
  (let ([trx #rx"^cpu time: ([0-9]+) real time: ([0-9]+) gc time: ([0-9]+)"])
    (lambda (str)
      (define M (regexp-match trx str))
      (if M
        (for/list ([x (in-list (cdr M))])
          (define num (string->number x))
          (if num num (raise-arguments-error 'parse-time "failed to parse number of regexp (impossible)" "bad string" x "rx-match" M  "input" str)))
        (raise-arguments-error 'parse-time "invalid time string" "input" str)))))

(define (filename->benchmark-name str)
  (string-join (drop-right (string-split str "-") 1) "-"))

(writeln (collect-all))
