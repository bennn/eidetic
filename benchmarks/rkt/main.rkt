#lang racket/base

;; TODO
;; - hey think about the API you want....
;;   probably going to be "file suffix patterns"
;;   - maybe can migrate to "datasets", but like, idk

(require racket/contract)
(provide
  *VERSIONS*
  get-data-files

  (contract-out
   [run-all
    (->* () () #:rest (listof (and/c path-string? directory-exists?)) datatable?)]
   [collect-data
    ;; TODO right API ?
    ;; none/c = (and/c path-string? file-exists?)
    (->* () () #:rest (listof none/c) datatable?)]
   [plot-data
    (-> (and/c datatable? well-formed-datatable?) pict?)]
))

(require
  pict
  plot/no-gui
  plot/utils
  racket/format
  racket/string
  math/statistics)

;; =============================================================================

(define *VERSIONS* (make-parameter '()))

(define DEFAULT-BM* (map symbol->string '(
  acquire-worst array forth-bad forth-worst fsm-bad fsmoo-bad fsmoo-worst
  fsm-worst-case graph gregor-worst jpeg kcfa-worst lnm-worst mbta-worst
  morsecode-worst quadBG-worst quadMB-bad quadMB-worst snake-worst
  suffixtree-worst synth synth-worst take5-worst tetris-worst trie-vector
  zombie-worst zordoz-worst)))

;; -----------------------------------------------------------------------------

(struct datatable [title* row*]
  #:transparent
  #:methods gen:custom-write
  [(define (write-proc D port write?)
     (if write?
       (writeln (cons 'datatable (cons (datatable-title* D) (datatable-row* D))) port)
       (begin
         ;; TODO this is not org
         (displayln (org-join (map title-name (datatable-title* D))) port)
         (displayln (org-sep) port)
         (for ((r (in-list (datatable-row* D))))
           (displayln (org-join (fixup r)) port))
         (void))))])

(struct title [name ctc]
  #:transparent
  #:property prop:procedure (struct-field-index ctc)
  #:methods gen:custom-write
  [(define (write-proc t port write?)
     (if write?
       (write (title-name t) port)
       (fprintf port "#<~a:~a>" (title-name t) (title-ctc t))))])

(define (fixup x*)
  (cons (~a (car x*)) (for/list ((ns (in-list (cdr x*)))) (rnd (mean ns)))))

(define (org-join x*)
  (string-append
    "| "
    (string-join (map ~a x*) " | ")
    " |"))

(define (org-sep)
  "+===")

(define (well-formed-datatable? D)
  (and (datatable? D)
       (for/and ([r (in-list (datatable-row* D))])
         (let loop ([r r]
                    [t (datatable-title* D)])
           (cond
            [(and (null? r) (null? t))
             #true]
            [(or (null? r) (null? t))
             (raise-arguments-error 'well-formed-datatable "row shape does not match column shape" "row" r "shape" (datatable-title* D) "datatable" D)
             #false]
            [((car t) (car r))
             (loop (cdr r) (cdr t))]
            [else
             (raise-argument-error 'well-formed-datatable "value does not match spec" "value" (car r) "spec" (car t) "datatable" D)
             #false])))))

(define (collect-data . dir*)
  (error 'TODO))

(define (run-all . dir*)
  (error 'TODO))

(define (get-data-files ctrl-suffix #:experimental exp-suffix* #:benchmark [benchmark-name* DEFAULT-BM*])
  (datatable
    (list*
      (title "benchmark" string?)
      (title ctrl-suffix runtimes?)
      (for/list ([exp (in-list exp-suffix*)])
        (title exp runtimes?)))
    (for/list ((bm (in-list benchmark-name*)))
      (list*
        bm
        (file->data (format "~a-~a.txt" bm ctrl-suffix))
        (for/list ([exp (in-list exp-suffix*)])
          (file->data (format "~a-~a.txt" bm exp)))))))

(define runtimes?
  (listof real?))

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

(define (plot-data D)
  (parameterize ((plot-font-size 7)
                 (plot-x-ticks no-ticks))
    (plot-pict
      (list*
        (hrule 1)
        (for/list ([x-min (in-naturals)]
                   [col-title (in-list (cddr (datatable-title* D)))])
          (discrete-histogram
            #:skip 6
            #:x-min x-min
            #:label (~s col-title)
            #:color (+ x-min 1)
            (for/list ([r (in-list (datatable-row* D))])
              (define name (car r))
              (define control (cadr r))
              (define experimental (list-ref r (+ 2 x-min)))
              (vector name (/ (mean experimental) (mean control)))))))
      #:title "Overhead vs. racket-contract"
      #:legend-anchor 'top-right
      #:y-max 1.5
      #:width 2000
      #:x-label "Benchmark"
      #:y-label "Slowdown factor (e.g. 2 means '2x slower')")))

;; =============================================================================

(module* main racket/base
  (require
    racket/contract
    racket/cmdline
    racket/port
    (submod "..")
    (only-in pict pict->bitmap)
    (only-in racket/class send))

  (define (save-pict fn p)
    (define bm (pict->bitmap p))
    (send bm save-file fn 'png))

  (define (string->listof-string str)
    (if (eq? #\( (string-ref str 0))
      (with-input-from-string str read)
      (list str)))

  ;(define (main argv)
    (define mode (box #f))
    (command-line
     #:program "benchmark-run"
     #:once-any
     [("-c" "--collect") ", create a datatable" (set-box! mode 'collect)]
     [("-p" "--plot") "Plot a datatable" (set-box! mode 'plot)]
     [("-r" "--run") "Run benchmarks" (set-box! mode 'run)]
     #:once-each
     [("-v" "--version") vp "Racket versions to run" (*VERSIONS* (string->listof-string vp))]
     #:args arg*
     (case (unbox mode)
      [(collect)
       (define D (apply collect-data arg*))
       (with-output-to-file "TABLE.rktd"
         (λ () (writeln D)))
       (with-output-to-file "TABLE.org"
         (λ () (displayln D)))
       (void)]
      [(plot)
       (unless ((list/c (and/c path-string? directory-exists?)) arg*)
         (raise-argument-error 'main "bad input to plot sorry pls read source"))
       (define D
         (parameterize ([current-directory (car arg*)])
           (get-data-files "6.9" #:experimental '("rc" "ls" "ls2"))))
       (with-output-to-file "TABLE.org"
         (λ () (displayln D)))
       (define p (plot-data D))
       (define out "out.png")
       (save-pict out p)
       (printf "Saved plot to '~a'~n" out)
       (void)]
      [(run)
       (run-all arg*)]
      [else
       (raise-user-error 'benchmark-tool "Please supply either the '--collect' '--plot' or '--run' flag on the command line")
       #;(main '#("--help"))]))
  #;(main (current-command-line-arguments)))
