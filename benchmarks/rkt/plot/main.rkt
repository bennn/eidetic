#lang racket/base
(require plot/compat)

(define (trig x y) (* (sin x) (sin y)))

(time (void
  (plot (mix (shade trig) (contour trig) (vector-field (gradient trig) #:samples 25 #:color 'black))
    #:x-min -1.5 #:x-max 1.5 #:y-min -1.5 #:y-max 1.5
    #:title "gradient field +shdade + contours of F(x,y) = sin(x) * sin(y)")))
