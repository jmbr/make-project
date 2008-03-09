(in-package :cl-user)

(defpackage :make-project
  (:use :common-lisp :cl-interpol)
  (:export :make-project))

(in-package :make-project)

(enable-interpol-syntax)

(defparameter *prefix-dir* "/home/jmbr/projects/")
(defparameter *prefix* "com.superadditive.")
(defparameter *license*
#?[;;; Copyright (c) 2008 Juan M. Bello Rivas <jmbr@superadditive.com>
;;; 
;;; Permission is hereby granted, free of charge, to any person
;;; obtaining a copy of this software and associated documentation
;;; files (the "Software"), to deal in the Software without
;;; restriction, including without limitation the rights to use, copy,
;;; modify, merge, publish, distribute, sublicense, and/or sell copies
;;; of the Software, and to permit persons to whom the Software is
;;; furnished to do so, subject to the following conditions:
;;; 
;;; The above copyright notice and this permission notice shall be
;;; included in all copies or substantial portions of the Software.
;;; 
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;;; DEALINGS IN THE SOFTWARE.]
)

(defun make-project (name description)
  (let* ((dirname #?"${*prefix-dir*}/${name}")
         (asd-filename #?"${dirname}/${name}.asd")
         (package-filename #?"${dirname}/package.lisp")
         (main-filename #?"${dirname}/${name}.lisp"))
   (iolib-posix:mkdir dirname #o755)
   (with-open-file (asd-file asd-filename :direction :output)
     (format asd-file
#?[${*license*}

(defpackage :${*prefix*}${name}-system
  (:use :common-lisp :asdf))

(in-package :${*prefix*}${name}-system)

(defsystem "${name}"
  :description "${description}"
  :author "Juan M. Bello Rivas <jmbr@superadditive.com>"
  :licence "X11"
;  :depends-on ("")
  :serial t
  :components ((:file "package")
               (:file "${name}")))
]))
   (with-open-file (package-file package-filename :direction :output)
     (format package-file
#?[${*license*}

(in-package :cl-user)

(defpackage :com.superadditive.${name}
  (:nicknames :${name})
  (:use :common-lisp)
;  (:export ...)
  )
]))
   (with-open-file (main-file main-filename :direction :output)
     (format main-file
#?[${*license*}

(in-package :${*prefix*}${name})

]))))
