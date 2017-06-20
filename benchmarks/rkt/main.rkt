#lang racket/base

;; TODO
;; - hey think about the API you want....
;;   probably going to be "file suffix patterns"
;;   - maybe can migrate to "datasets", but like, idk

(require racket/contract)
(provide
  *VERSIONS*
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
  racket/format)

;; =============================================================================

(define *VERSIONS* (make-parameter '()))

;; -----------------------------------------------------------------------------

(struct datatable [title* row*]
  #:transparent
  #:methods gen:custom-write
  [(define (write-proc D port write?)
     (if write?
       (writeln (cons 'datatable (cons (datatable-title* D) (datatable-row* D))) port)
       (begin
         (displayln (org-join (datatable-title* D)) port)
         (displayln (org-sep) port)
         (for ((r (in-list (datatable-row* D))))
           (displayln (org-join r) port))
         (void))))])

(struct title [name ctc]
  #:transparent
  #:property prop:procedure (struct-field-index ctc)
  #:methods gen:custom-write
  [(define (write-proc t port write?)
     (if write?
       (write (title-name t) port)
       (fprintf port "#<~a:~a>" (title-name t) (title-ctc t))))])

(define (org-join x*)
  (string-append
    "| "
    (~a x* #:separator " | ")
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

(define (plot-data arg*)
  (error 'TODO))

;; =============================================================================

(module* main racket/base
  (require racket/cmdline racket/port (submod ".."))

  (define (string->listof-string str)
    (if (eq? #\( (string-ref str 0))
      (with-input-from-string str read)
      (list str)))

  (define (main argv)
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
       (apply plot-data arg*)]
      [(run)
       (run-all arg*)]
      [else
       (main '#("--help"))])))
  (main (current-command-line-arguments)))
