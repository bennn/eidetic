#lang racket/base
(require racket/contract)
(provide
  tower/c
  board/c

  (contract-out
   [struct disk ([size natural?])]
   [make-board (-> #:disks natural? #:pegs natural? board/c)]
   [move-disk! (->i ([board board/c]
                     [from (board) (and/c natural? (</c (board->num-pegs board)))]
                     [to (board) (and/c natural? (</c (board->num-pegs board)))])
                    #:pre/name (board from) "source peg has no disks"
                    (board-has-disk? board from)
                    #:pre/name (board from to) "destination peg has smaller disk than source peg"
                    (or (not (board-has-disk? board to))
                        (disk-size<? (board->disk board from) (board->disk board to)))
                    [rng void?])]
   [format-board (-> board/c string?)]
   [find-target* (->i ([H  board/c]
                       [i (H) (and/c natural? (</c (board->num-pegs H)))])
                      [rng (listof natural?)])]
   [board-has-disk? (->i ([H board/c]
                          [i (H) (and/c natural? (</c (board->num-pegs H)))])
                         [rng boolean?])]
  ))

(require
  (only-in racket/list
    append*
    make-list)
  (only-in racket/string
    string-join)
  (only-in racket/math
    natural?))

;; =============================================================================

(struct disk [size]
  #:transparent
  #:extra-constructor-name make-disk)

(define tower/c
  (listof disk?))

(define board/c
  (vectorof tower/c))

(define (disk-size<? d1 d2)
  (< (disk-size d1) (disk-size d2)))

(define (board->disk H i)
  (define d* (vector-ref H i))
  (if (null? d*)
    (raise-arguments-error 'board->disk "(board-has-disk? H i)" "H" H "i" i)
    (car d*)))

(define (find-target* H from)
  (define from-size
    (if (board-has-disk? H from)
      (disk-size (board->disk H from))
      #false))
  (for/list ([i (in-range (board->num-pegs H))]
             #:when (or (not (board-has-disk? H i))
                        (not from-size)
                        (< from-size (disk-size (board->disk H i)))))
    i))

(define (find-largest-disk H)
  (cdr
    (for/fold ([acc #f])
              ([i (in-range (board->num-pegs H))])
      (if (board-has-disk? H i)
        (let ([d (board->disk H i)])
          (if (or (not acc) (< (disk-size (car acc)) (disk-size d))) (cons d i) acc))
        acc))))

(define (board-has-disk? H i)
  (not (null? (vector-ref H i))))

(define (board->num-pegs H)
  (vector-length H))

(define (make-board #:disks num-disks #:pegs num-pegs)
  (define t (make-vector num-pegs '()))
  (vector-set! t 0 (make-tower num-disks))
  t)

(define (move-disk! H from to)
  (vector-set! H to (cons (board->disk H from) (vector-ref H to)))
  (vector-set! H from (cdr (vector-ref H from)))
  (void))

(define (make-tower num-disks)
  (build-list num-disks (compose1 make-disk add1)))

(define (format-board H)
  (define N (board->num-disks H))
  (define W (max-disk-width H))
  (define pad-str (make-string 2 #\space))
  (define t-str**
    (for/list ([t (in-vector H)])
      (format-tower t W N)))
  (define row*
    (let loop ((t-str** t-str**))
      (if (null? (car t-str**))
        '()
        (cons (string-join (map car t-str**) pad-str) (loop (map cdr t-str**))))))
  (string-append (string-join row* "\n")
                 "\n"
                 (format-floor row*)
                 "\n"))

(define (format-floor row*)
  (make-string (string-length (car row*)) #\=))

(define (format-tower t W total-num-disks)
  (append
    (make-list (- total-num-disks (length t)) (format-disk (make-disk 1) W #\|))
    (for/list ([d (in-list t)])
      (format-disk d W))))

(define (format-disk d W [fill-char #\X])
  (define d-str (make-string (natural->odd (disk-size d)) fill-char))
  (define pad-str (make-string (- W (disk-size d)) #\SPACE))
  (string-append pad-str d-str pad-str))

(define (natural->odd n)
  (+ n (- n 1)))

(define (max* n*)
  (if (null? n*)
    (raise-argument-error 'max* "non-empty list" n*)
    (for/fold ([acc (car n*)])
              ([n (in-list (cdr n*))])
      (max acc n))))

(define (board->num-disks H)
  (length (board->disk* H)))

(define (max-disk-width H)
  (max* (map disk-size (board->disk* H))))

(define (board->disk* H)
  (append* (for/list ([t (in-vector H)]) (tower->disk* t))))

(define (tower->disk* t)
  t)

;; =============================================================================

(module+ test
  (require rackunit)

  (test-case "format-board"
    (check-equal?
      (format-board (make-board #:disks 3 #:pegs 3))
      (string-append
        "  X      |      |  \n"
        " XXX     |      |  \n"
        "XXXXX    |      |  \n"
        "===================\n"))

    (check-equal?
      (let ([H (make-board #:disks 3 #:pegs 3)])
        (move-disk! H 0 1)
        (format-board H))
      (string-append
        "  |      |      |  \n"
        " XXX     |      |  \n"
        "XXXXX    X      |  \n"
        "===================\n"))

    (check-equal?
      (let ([H (make-board #:disks 3 #:pegs 3)])
        (move-disk! H 0 1)
        (move-disk! H 0 2)
        (format-board H))
      (string-append
        "  |      |      |  \n"
        "  |      |      |  \n"
        "XXXXX    X     XXX \n"
        "===================\n"))

    (check-equal?
      (let ([H (make-board #:disks 3 #:pegs 3)])
        (move-disk! H 0 2)
        (move-disk! H 0 1)
        (move-disk! H 2 0)
        (format-board H))
      (string-append
        "  |      |      |  \n"
        "  X      |      |  \n"
        "XXXXX   XXX     |  \n"
        "===================\n")))


  (test-case "natural->odd"
    (for ((n (in-range 1 16))
          (odd (in-range 1 30 2)))
      (check-equal? (natural->odd n) odd)))

)
