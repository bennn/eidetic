#lang racket/base

;; Goal:
;;  Exploratory data analysis on the contract wrapping logs.
;;
;;  Need a better picture of what the contracts are doing.
;;  (ALSO NEED MORE BENCHMARKS SO PLEASE GET BACK TO WORK)

;; Subgoals:
;; [X] any lines not about s-e-contract-wrapping ?
;; [X] and data malformed, doesn't match expectation ?
;; [X] how many times each branch taken?
;; [X] how many times each type encountered?
;; [ ] how many times enter SE mode?
;; [ ] how close to SE mode?
;; [ ] is the 'continue' branch extra slow?

;; Context:
;; - multi-ho/c & space-efficient-property & space-efficient-count-property & space-efficient-wrapper-property
;;   are all transparent, to get the equal-hash-code
;; - 

;; -----------------------------------------------------------------------------

(require
  file/glob
  (only-in racket/port
    with-input-from-string)
  (only-in racket/math
    natural?)
  (only-in racket/format
    ~a)
  racket/string
  racket/runtime-path)

(module+ test
  (require rackunit))

;; -----------------------------------------------------------------------------

(define-runtime-path CWD ".")

(define DATA
  (build-path CWD "output-2017-12-17"))

(define (benchmark-data name)
  ;; Data for one benchmark, eg. `tetris-worst`, is in N files:
  ;;  `tetris-worst-master-0.txt` ... `tetris-worst-master-$((N - 1)).txt`
  (glob (build-path DATA (format "~a-master-?.txt" name))))

(struct s-e-wrap-info (type branch val res ctc blame neg-party) #:prefab)
;; type : (or/c 'vectorof 'vector/c 'arrow)
;;  '
;; branch : (or/c 'no-chap non-s-e-chap collapse continue increment 
;;  'no-chap = 
;;  'non-s-e-chap = 
;;  'collapse = 
;;  'continue = 
;;  'increment = 
;; val : natural
;;  equal-hash-code for value going in to the merge
;; res : natural
;;  equal-hash-code for value going out of the merge
;; ctc : natural
;;  equal-hash-code for contract
;; blame : natural
;;  equal-hash-code for incomplete blame object
;; neg-party : natural
;;  equal-hash-code for negative party

(define logger-name
  "s-e-contract-wrapping")

(define (se-wrap-line? ln)
  (string-prefix? ln logger-name))

(define (parse-line ln)
  (if (se-wrap-line? ln)
    (parse-wrap-info (substring ln (+ 2 (string-length logger-name)) (string-length ln)))
    (values #f "not a wrap-line?")))

(module+ test
  (test-case "parse-line"
    (check-pred values (parse-line "s-e-contract-wrapping: #s(s-e-wrap-info arrow non-s-e-chap 3874 3875 3926 1992042824493479138 52453893760883310)"))))

(define (parse-wrap-info str)
  (define v (with-input-from-string str read))
  (if (s-e-wrap-info? v)
    (let ((wi (invalid-s-e-wrap-info? v)))
      (if wi
        (values #f wi)
        (values #t v)))
    (values #f "not a wrap-info?")))

(define (invalid-s-e-wrap-info? v)
  (cond
   [(not (valid-type? (s-e-wrap-info-type v)))
    (format "invalid type ~a" (s-e-wrap-info-type v))]
   [(not (valid-branch? (s-e-wrap-info-branch v)))
    (format "invalid branch ~a" (s-e-wrap-info-branch v))]
   [(not (valid-val? (s-e-wrap-info-val v)))
    (format "invalid val ~a" (s-e-wrap-info-val v))]
   [(not (valid-res? (s-e-wrap-info-res v)))
    (format "invalid res ~a" (s-e-wrap-info-res v))]
   [(not (valid-ctc? (s-e-wrap-info-ctc v)))
    (format "invalid ctc ~a" (s-e-wrap-info-ctc v))]
   [(not (valid-blame? (s-e-wrap-info-blame v)))
    (format "invalid blame ~a" (s-e-wrap-info-blame v))]
   [(not (valid-neg-party? (s-e-wrap-info-neg-party v)))
    (format "invalid neg-party ~a" (s-e-wrap-info-neg-party v))]
   [else #false]))

(define (valid-type? t)
  (memq t '(vectorof vector/c arrow)))

(define (valid-branch? b)
  (memq b '(no-chap non-s-e-chap collapse continue increment)))

(define valid-val? fixnum?)
(define valid-res? fixnum?)
(define valid-ctc? fixnum?)
(define valid-blame? fixnum?)
(define valid-neg-party? fixnum?)

;; -----------------------------------------------------------------------------
;; linting

(define (lint* f*)
  (if (null? f*)
    (void)
    (let ()
      (printf "Linting files ~a ...~n" f*)
      (define r* (map lint-file f*))
      (displayln (format-lint-summary r*)))))

(define (lint-file f)
  (define-values [wrapping-lines WL++] (make-counter))
  (define-values [other-lines OL++] (make-counter))
  (define-values [good-wraps GW++] (make-counter))
  (define-values [bad-wraps bw++] (make-counter))
  (define-values [all-lines AL++] (make-counter))
  (define bad-values (box '()))
  (define (BW++ v)
    (bw++)
    (printf "bad wrap in line ~a because ~a~n" (unbox all-lines) v)
    #;(set-box! bad-values (cons v (unbox bad-values)))
    (void))
  (define (do-line ln)
    (AL++)
    (with-handlers ((parse-error?
                     (lambda (e)
                       (raise-user-error "ERROR on line ~a~n~a~n" (unbox all-lines) (exn-message e))
                       (void))))
      (cond
       [(se-wrap-line? ln)
        (WL++)
        (define-values [success? v] (parse-line ln))
        (if success? (GW++) (BW++ v))]
       [else
        (OL++)
        (void)])))
  (void
    (with-input-from-file f
      (lambda ()
        (for ((ln (in-lines)))
          (do-line ln)))))
  `((wrapping-lines ,(unbox wrapping-lines))
    (good-wraps ,(unbox good-wraps))
    (other-lines ,(unbox other-lines))
    (bad-wraps ,(unbox bad-wraps))
    (bad-values ,(unbox bad-values))))

(define (format-lint-summary result*)
  ;; waste of time to implement this now
  (string-join
    (for/list ((r (in-list result*)))
      (string-join (map ~a r) "\n"))
    "\n"))

;; -----------------------------------------------------------------------------
;; count branches

(define (branch* f*)
  (if (null? f*)
    (void)
    (let ()
      (printf "Counting branches in files ~a ...~n" f*)
      (define r* (map branch-file f*))
      (displayln (format-branch-summary r*)))))

(define (branch-file f)
  (define-values [all-lines AL++] (make-counter))
  (define T (make-hash '((vectorof . 0) (vector/c . 0) (arrow . 0))))
  (define B (make-hash '((no-chap . 0) (non-s-e-chap . 0) (collapse . 0) (continue . 0) (increment . 0))))
  (define (count++ H k)
    (hash-update! H k add1 (lambda () (raise-user-error 'bad-key "~a" k))))
  (define (do-line ln)
    (AL++)
    (with-handlers ((parse-error?
                     (lambda (e)
                       (raise-user-error "ERROR on line ~a~n~a~n" (unbox all-lines) (exn-message e))
                       (void))))
      (cond
       [(se-wrap-line? ln)
        (define-values [success? v] (parse-line ln))
        (if success?
          (begin
            (count++ T (s-e-wrap-info-type v))
            (count++ B (s-e-wrap-info-branch v))
            (void))
          (raise-user-error 'bad-val "~a~n" v))
        (void)]
       [else
        (void)])))
  (void
    (with-input-from-file f
      (lambda ()
        (for ((ln (in-lines)))
          (do-line ln)))))
  (cons T B))

(define (format-branch-summary bs*)
  (string-join
    (for/list ((bs (in-list bs*)))
      (define T (car bs))
      (define B (cdr bs))
      (string-append
        "type info:\n"
        (format-hash T)
        "\nbranch info:\n"
        (format-hash B)))
    "\n"))

(define (format-hash H)
  (string-join (for/list (((k v) (in-hash H))) (format "- ~a : ~a" k v)) "\n"))

;; -----------------------------------------------------------------------------
;; util

(define (make-counter)
  (define b (box 0))
  (define (b++) (set-box! b (+ 1 (unbox b))))
  (values b b++))

(define (parse-error? e)
  (or (exn:fail:contract? e) (exn:fail:read? e)))

;; -----------------------------------------------------------------------------

(module+ main
  (require racket/cmdline)
  (define to-lint (box '()))
  (define to-count-branch (box '()))
  (command-line
    #:program "s-e-contract-wrapping"
    #:once-any
    [("--lint" "-l") lf "Spot-check a data file" (set-box! to-lint (cons lf (unbox to-lint)))]
    [("--branch" "-b") lf "Count occurrences of each cond branch" (set-box! to-count-branch (cons lf (unbox to-count-branch)))]
    #:args ()
    (let ()
      (lint* (unbox to-lint))
      (branch* (unbox to-count-branch))
      (void))))
