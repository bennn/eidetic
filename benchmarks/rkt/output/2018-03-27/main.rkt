#lang racket/base

(require
  racket/file
  file/glob
  racket/path
  racket/port
  racket/list
  racket/string
  (only-in gtp-measure/private/parse
           manifest->targets)
  racket/runtime-path)

(module+ test
  (require rackunit))

;; -----------------------------------------------------------------------------

(define-runtime-path racket-contract
  "./racket-contract")

(define-runtime-path racket-6.12
  "./racket-6.12")

(define (directory->names dir)
  (with-input-from-file (build-path dir "manifest.rkt")
    (lambda ()
      (for/list ((ln (in-lines))
                 #:when (string-prefix? ln "(")) ;)
        (string->filename (car (string->value ln)))))))

(define (string->value str)
  (with-input-from-string str read))

(define (string->filename str)
  (last (string-split str "/")))

(define (benchmark->out* bm)
  (define rc (dir->out* racket-contract bm))
  (define r6 (dir->out* racket-6.12 bm))
  (values rc r6))

(define (dir->out* dir bm)
  (glob (build-path dir (format "*~a*out" bm))))

(define (just-cpu-time data)
  (with-output-to-file (path-add-extension data #".rktd" #".") #:exists 'replace
    (lambda ()
      (with-input-from-file data
        (lambda ()
          (writeln
            (for/vector ((ln (in-lines)))
              (define v (string->value ln))
              (map string->cpu-time (cadr v)))))))))

(define (string->cpu-time str)
  (string->number (cadr (regexp-match #rx"^cpu time: ([0-9]+) " str))))

(module+ main
  (define bm* (directory->names racket-contract))
  (for ((bm (in-list bm*)))
    (define-values [rc-out* r6-out*] (benchmark->out* bm))
    (define num-rc (length rc-out*))
    (define num-r6 (length r6-out*))
    (when (and (= 1 num-rc) (= num-rc num-r6))
      (define rc-data (just-cpu-time (car rc-out*)))
      (define r6-data (just-cpu-time (car r6-out*)))
      (error 'die))))
      
