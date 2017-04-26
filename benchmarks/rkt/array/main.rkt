#lang racket/base
(require math/array)

(time (void
  (array-andmap equal? (array #[1 2 3]) (array #[2 1 3]))
  (array-ormap equal? (array #[1 2 3]) (array #[2 1 3]))))
