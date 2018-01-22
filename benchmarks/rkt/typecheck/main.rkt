#lang racket/base

(require file/glob)

(void
  (for-each delete-file (glob (build-path "compiled" "new-metrics*"))))

(time
  (dynamic-require "new-metrics.rkt" #f))
