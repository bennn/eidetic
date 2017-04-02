#lang racket/base

;; TODO
;; - is 2-arity a huge help?
;; - I guess whats wrong is,
;;   the function that builds the chaperone to apply to `f`
;;   somehow doesn;t have access to f?
;;   Else idk what could be wrong

(module implementation racket/base
  (provide
    apply-arrow-contract
    ;; (-> (-> A? B?) C? D? (-> C? D?))
    ;; (apply-arrow-contract f c? d?)
    ;; Returns a function `f+` that acts ilke `f`, but raises an error if:
    ;; - `f+` is given a value that does not satisfy `c?`
    ;; - `f+` returns a value that does not satisfy `d?`
    ;; Calls like `(apply-arrow-contract (apply-arrow-contract ....) ....)`
    ;;  try to omit redundant domain/codomain checks.
  )

  (define (apply-arrow-contract pre-f dom cod)
    (define-values [f old-dom* old-cod*]
      (get-arrow-coercion pre-f))
    (define-values [new-dom* new-cod*]
      (values (coercion-list-cons dom old-dom*) (coercion-list-cons cod old-cod*)))
    (chaperone-procedure f
      (lambda (x)
        (coercion-list-apply new-dom* x)
        (define (result-wrapper-proc y)
          (coercion-list-apply new-cod* y)
          y)
        (values result-wrapper-proc x))
      eidetic-property
      (arrow-coercion f new-dom* new-cod*)))

  (struct arrow-coercion [
    f   ;; (-> any any) , the function that is getting coerced
    dom ;; (listof p?)  , ordered list of predicates, no _consecutive_ duplicates
    cod ;; (listof p?)  , same as `dom`, but for the codomain of `f`
  ] #:transparent)

  (define-values [eidetic-property has-eidetic-property? get-eidetic-property]
    (make-impersonator-property 'eidetic))

  ;; procedure? -> (values procedure? coercion-list? coercion-list?)
  (define (get-arrow-coercion f)
    (if (not (has-eidetic-property? f))
      (values f '() '())
      (let ([v (get-eidetic-property f)])
        (unless (arrow-coercion? v)
          (raise-arguments-error 'get-arrow-coercion "function with arrow-coercion eidetic property" "function" f "property" v))
        (values (arrow-coercion-f v) (arrow-coercion-dom v) (arrow-coercion-cod v)))))

  ;; (listof p?) any -> void
  (define (coercion-list-apply c* x)
    (for/and ([c (in-list (reverse c*))])
      (printf "COERCE (~a ~a)~n" c x)
      (unless (c x)
        (raise-user-error 'coercion "FAILURE"))))

  ;; p? (listof p?) -> (listof p?)
  (define (coercion-list-cons c c*)
    (if (and (not (null? c*))
             (eq? c (car c*)))
      (begin (printf "REDUNDANT ~a~n" c) c*)
      (cons c c*)))
)

;; -----------------------------------------------------------------------------

(module+ test
  (require rackunit (submod ".." implementation))

  (test-case "base"
    #;(printf "START~n")
    (define f add1)
    (check-equal? (f 0) 1)
    #;(printf "CHECKPOINT level 0~n")
    (define f+ (apply-arrow-contract f integer? integer?))
    (check-equal? (f+ 0) 1)
    #;(printf "CHECKPOINT level 1~n")
    (define f++ (apply-arrow-contract f+ integer? integer?))
    (check-equal? (f++ 0) 1)
    #;(printf "CHECKPOINT level 2~n")
    (define any? (lambda (x) #true))
    (define f+++ (apply-arrow-contract f++ any? boolean?))
    (check-exn #rx"coercion"
      (lambda () (f+++ 0))))


)
