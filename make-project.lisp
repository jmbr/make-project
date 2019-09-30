(in-package #:common-lisp)

(defpackage #:make-project
  (:use #:common-lisp #:cl-interpol)
  (:export #:make-project))

(in-package #:make-project)

(enable-interpol-syntax)

(defvar *prefix-dir*
  (merge-pathnames #p"sources/" (user-homedir-pathname))
  "Directory where the source code repositories are located.")
(defvar *prefix* "")

(defun make-project (name description)
  (let* ((dirname #?"${*prefix-dir*}${name}")
         (asd-filename #?"${dirname}/${name}.asd")
         (package-filename #?"${dirname}/package.lisp")
         (main-filename #?"${dirname}/${name}.lisp")
         (test-filename #?"${dirname}/test-suite.lisp"))
    (iolib/syscalls:mkdir dirname #o755)
    #+quicklisp
    (let ((linkpath #?"${quicklisp:*quicklisp-home*}/local-projects/${name}"))
      (iolib/syscalls:symlink dirname linkpath))
    (with-open-file (asd-file asd-filename :direction :output)
      (format asd-file
#?[(defsystem #:${name}
  :description "${description}"
  :author "Juan M. Bello Rivas <jmbr@superadditive.com>"
  :licence "X11"
;  :depends-on ()
  :serial t
  :components ((:file "package")
               (:file "${name}"))
  :in-order-to ((test-op (test-op "${name}/tests"))))

(defsystem #:${name}/tests
  :description "Test suite for ${name}."
  :depends-on (#:${name} #:fiasco)
  :components
  ((:file "test-suite")))

(defmethod perform ((op test-op) (system (eql (find-system "${name}"))))
  (let ((run-tests (find-symbol "ALL-TESTS" "FIASCO")))
    (funcall run-tests)))

(defmethod operation-done-p ((op test-op) (system (eql (find-system "${name}"))))
  nil)
]))

   (with-open-file (package-file package-filename :direction :output)
     (format package-file
#?[(defpackage #:${*prefix*}${name}
  (:use #:common-lisp)
;  (:export #:...)
  )

(defpackage #:${*prefix*}${name}-user
  (:use #:common-lisp #:${name}))
]))

   (with-open-file (main-file main-filename :direction :output)
     (format main-file
#?[(in-package #:${*prefix*}${name})

]))

   (with-open-file (test-file test-filename :direction :output)
     (format test-file
#?[(fiasco:define-test-package #:${*prefix*}${name}-test
  (:use #:${name}))

(in-package #:${*prefix*}${name}-test)

;; (deftest test-whatever ()
;;   (signals ...)
;;   (is (eql ...)))
]))))
