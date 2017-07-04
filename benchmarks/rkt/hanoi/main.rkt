#lang racket/base

(require
  "board.rkt"
  racket/class)

(define hanoi-solver%
  (class object%
    (super-new)
    (init-field num-disks num-pegs)
    (field [H (make-board #:disks num-disks #:pegs num-pegs)]
           [descending? #true])

    (define/public (solved?)
      (= 1 (for/sum ([i (in-range (get-field num-pegs this))])
             (if (board-has-disk? (get-field H this) i) 1 0))))

    (define/public (reset!)
      (set-field! H this
        (make-board #:disks (get-field num-disks this) #:pegs (get-field num-pegs this))))

    (define/public (format)
      (format-board (get-field H this)))

    (define/public (move-tower!)
      (unless (send this solved?)
        (raise-arguments-error 'move-tower! "board with 1 tower" "board" H))
      (define from
        (for/first ([i (in-range num-pegs)]
                    #:when (board-has-disk? H i))
          i))
      (define to (car (find-target* H from)))
      (let move-tower! ([from from]
                        [to to]
                        [tower-size num-disks])
        (case tower-size
         [(0)
          (void)]
         [else
          (define tmp (car (remove to (find-target* H from))))
          (move-tower! from tmp (- tower-size 1))
          (move-disk! H from to)
          (move-tower! tmp to (- tower-size 1))
          (void)])))
))

(define (main d p)
  (define S (new hanoi-solver% [num-disks d] [num-pegs p]))
  (display (send S format))
  (send S move-tower!)
  (display (send S format))
  (void))

(time (main 9 3))
