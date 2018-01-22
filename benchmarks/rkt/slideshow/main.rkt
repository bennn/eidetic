#lang racket/base

(require slideshow/slides-to-picts)

(module+ for-compile
  ;; make 'show.rkt' a compile-time dependency, but don't require show
  ;;  for the main computation
  (require "show.rkt"))


(time
  (void (get-slides-as-picts "show.rkt" 100 100 #false)))
