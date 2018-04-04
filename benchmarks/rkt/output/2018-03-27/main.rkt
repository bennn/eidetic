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
  (only-in gtp-plot/performance-info
           max-overhead)
  gtp-plot/typed-racket-info
  (only-in gtp-plot/plot
           samples-plot
           *SAMPLE-COLOR*
           *OVERHEAD-PLOT-WIDTH*
           *OVERHEAD-PLOT-HEIGHT*
           overhead-plot)
  gtp-util
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

(define samples? (make-parameter #f))

(define (benchmark->out* bm)
  (define rc (dir->out* racket-contract bm))
  (define r6 (dir->out* racket-6.12 bm))
  (values rc r6))

(define (dir->out* dir bm)
  (define extra (if (samples?) "?" ""))
  (glob (build-path dir (format "*~a~a.out" bm extra))))

(define (just-cpu-time data)
  (define file (path-add-extension data #".rktd" #"."))
  (with-output-to-file file #:exists 'replace
    (lambda ()
      (with-input-from-file data
        (lambda ()
          (writeln
            (for/vector ((ln (in-lines)))
              (define v (string->value ln))
              (map string->cpu-time (cadr v))))))))
  file)

(define (string->cpu-time str)
  (string->number (cadr (regexp-match #rx"^cpu time: ([0-9]+) " str))))

(define (t/u-configs t/u-path)
  (define v*
    (with-input-from-file t/u-path
      (lambda ()
        (for/list ((ln (in-lines)))
          (with-input-from-string ln read)))))
  (define-values [tv uv]
    (if (untyped? (car v*))
      (values (cadr v*) (car v*))
      (values (car v*) (cadr v*))))
  (values (parse-config tv) (parse-config uv)))

(define (untyped? x)
  (for/and ((c (in-string (car x))))
    (eq? c #\0)))

(define (parse-config v)
  (define id (car v))
  (define t* (map time-string->cpu-time (cadr v)))
  (make-typed-racket-configuration-info id t*))

(define (glob1 ps)
  (define m* (glob ps))
  (unless (= 1 (length m*))
    (raise-arguments-error 'glob1 "not 1 match" m*))
  (car m*))

(define (mks name data*)
  (define t/u-path (glob1 (build-path (path-only (car data*)) (format "*-~a.out" name))))
  (define-values [tc uc] (t/u-configs t/u-path))
  (make-typed-racket-sample-info data* #:name (string->symbol name) #:typed-configuration tc #:untyped-configuration uc))

(define (sample->name str)
  (define fn (path->string (file-name-from-path str)))
  (string->symbol (cadr (regexp-match #rx"-([^0-9]+)" str))))

(define (sample->num-units str)
  (quotient (num-lines str) 10))

(define (num-lines str)
  (with-input-from-file str
    (lambda ()
      (for/sum ((ln (in-lines))) 1))))

(module+ main
  (define bm* (directory->names racket-contract))
  (define (plot-overheads)
    (for ((bm (in-list bm*))
          #:when (string=? "synth" bm))
      (define-values [rc-out* r6-out*] (benchmark->out* bm))
      (define num-rc (length rc-out*))
      (define num-r6 (length r6-out*))
      (when (and (= 1 num-rc) (= num-rc num-r6))
        (define rc-data (just-cpu-time (car rc-out*)))
        (define r6-data (just-cpu-time (car r6-out*)))
        (define tr* (map make-typed-racket-info (list rc-data r6-data)))
        (define p (overhead-plot tr*))
        (printf "save pict ~a~n" bm)
        (save-pict (format "~a.png" bm) p)
        (void))))
  (define (max-overheads)
    (for/list ((bm (in-list bm*))
          #:when (string=? "fsm" bm))
      (define-values [rc-out* r6-out*] (benchmark->out* bm))
      (define num-rc (length rc-out*))
      (define num-r6 (length r6-out*))
      (when (and (= 1 num-rc) (= num-rc num-r6))
        (define rc-data (just-cpu-time (car rc-out*)))
        (define r6-data (just-cpu-time (car r6-out*)))
        (define tr* (map make-typed-racket-info (list rc-data r6-data)))
        (cons bm (map max-overhead tr*)))))

  (define (plot-samples [type2? #false])
    (parameterize ((samples? #true))
      (for ((bm (in-list bm*))
            #:when (or (string-contains? bm "gregor") (string-contains? bm "quadMB")))
        (define-values [rc-out* r6-out*] (benchmark->out* bm))
        (define rc-data* (map just-cpu-time rc-out*))
        (define r6-data* (map just-cpu-time r6-out*))
        (define si* (list (mks bm rc-data*) (mks bm r6-data*)))
        (if type2?
          (for ([si (in-list si*)]
                [c (in-naturals 3)])
            (parameterize ([*SAMPLE-COLOR* c]
                           [*OVERHEAD-PLOT-WIDTH* 400]
                           [*OVERHEAD-PLOT-HEIGHT* 200])
              (save-pict (format "~a-~a.png" bm c) (samples-plot si))))
          (let ([p (samples-plot si*)])
            (save-pict (format "~a.png" bm) p)))
        (void))))

  ;(plot-overheads)
  ;(max-overheads)
  ;(plot-samples)
  (plot-samples #true)
  (void))
