(common-lisp:in-package :common-lisp)

(defpackage :make-project
  (:use :common-lisp :cl-interpol :incf-cl)
  (:export :make-project))

(in-package :make-project)

(defparameter *project-prefix-dir* "/home/jmbr/projects/")

(cl-interpol:enable-interpol-syntax)

(defun make-project (name description)
  (let* ((directory-name (string-join (list *project-prefix-dir* name) ""))
         (asd-file-name (string-join (list directory-name "/" name ".asd") "")))
   (iolib-posix:mkdir directory-name #o755)
   (iolib-posix:chdir directory-name)
   (with-open-file (asd-file asd-file-name :direction :output)
     (format asd-file
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
;;; DEALINGS IN THE SOFTWARE.

(defpackage :${name}-system
  (:use :common-lisp :asdf))

(in-package :${name}-system)

(defsystem "${name}"
  :description "${description}"
  :author "Juan M. Bello Rivas <jmbr@superadditive.com>"
  :licence "X11"
;  :depends-on ("")
  :serial t
  :components ((:file "package")
               (:file "${name}")))
]))))
