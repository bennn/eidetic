#lang racket/base
(require plot/no-gui (only-in plot/compat gradient))

(define (trig x y) (* (sin x) (sin y)))

(time (void
  (plot3d-pict (isosurfaces3d (compose abs max) -1 1 -1 1 -1 1))
  (plot-pict (mix (shade trig) (contour trig) (vector-field (gradient trig) #:samples 25 #:color 'black))
    #:x-min -1.5 #:x-max 1.5 #:y-min -1.5 #:y-max 1.5
    #:title "gradient field +shdade + contours of F(x,y) = sin(x) * sin(y)")))
