#lang racket
;; guile-jpeg
;; Copyright (C) 2014 Andy Wingo <wingo at pobox dot com>

;; This library is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3 of the License, or (at
;; your option) any later version.
;;
;; This library is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this library; if not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; A parser for JPEG.
;;
;;; Code:

(provide jpeg-dimensions
         jpeg-dimensions-and-exif
         jpeg->rgb
         rgb->jpeg
         rgb-buffer->jpeg
         read-jpeg
         write-jpeg)
(require "jfif.rkt" "exif.rkt" "dct.rkt" "pixbufs.rkt")

(define (jpeg-dimensions jpeg)
  (let* ((jfif (if (jfif? jpeg)
                   jpeg
                   (read-jfif jpeg #:with-body? #f #:with-misc-sections? #f)))
         (frame (jfif-frame jfif)))
    (values (frame-x frame)
            (frame-y frame))))

(define (read-jpeg jpeg)
  (read-jfif jpeg))

(define (write-jpeg port jpeg)
  (write-jfif port jpeg))

(define (find-exif misc-segments)
  (define (bv-prefix? prefix bv)
    (and (>= (bytes-length bv) (bytes-length prefix))
         (let lp ((n 0))
           (or (= n (bytes-length prefix))
               (and (eqv? (bytes-ref prefix n) (bytes-ref bv n))
                    (lp (add1 n)))))))
  (filter-map (lambda (misc)
                (and (= (misc-marker misc) #xffe1) ; APP1
                     (bv-prefix? (bytes 69 120 105 102 0 0) (misc-bytes misc))
                     (parse-exif (subbytes (misc-bytes misc) 6))))
              misc-segments))

(define (jpeg-dimensions-and-exif jpeg)
  (let* ((jfif (if (jfif? jpeg)
                   jpeg
                   (read-jfif jpeg #:with-body? #f)))
         (frame (jfif-frame jfif)))
    (values (frame-x frame)
            (frame-y frame)
            (match (find-exif (jfif-misc-segments jfif))
              ((list (list main thumbnail)) main)
              ((list (list main)) main)
              (_ '())))))

(define (jpeg->rgb in
                   #:argb? (argb? #f)
                   #:stride-for-width (stride-for-width
                                       (lambda (width)
                                         (* width (if argb? 4 3)))))
  (let ((jfif (if (jfif? in) in (read-jfif in))))
    (yuv->rgb (jpeg->planar-image jfif)
              #:argb? argb?
              #:stride (stride-for-width (frame-x (jfif-frame jfif))))))

(define (rgb->jpeg rgb #:samp-x (samp-x 2) #:samp-y (samp-y 2)
                   #:quality (quality 85))
  (planar-image->jpeg (rgb->yuv rgb #:samp-x samp-x #:samp-y samp-y)
                      #:quality quality))

(define (rgb-buffer->jpeg buffer width height #:stride (stride (* width 3))
                          #:samp-x (samp-x 2) #:samp-y (samp-y 2)
                          #:quality (quality 85) #:argb? (argb? #f))
  (rgb->jpeg (interleaved-image width height (if argb? 4 3) stride
                                buffer)
             #:samp-x samp-x #:samp-y samp-y #:quality quality))

