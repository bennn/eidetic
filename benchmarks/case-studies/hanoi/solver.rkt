#lang racket/base

(require "board.rkt" racket/contract racket/class (only-in racket/math natural?))

(provide
  (contract-out
    (hanoi-solver%
     (class/c
       (init-field (num-disks natural?)
                   (num-pegs natural?))
       (field (H board/c)
              (descending? boolean?))
       (solved? (->m boolean?))
       (reset! (->m void?))
       (format (->m string?))
       (move-tower! (->m void?))))))

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

