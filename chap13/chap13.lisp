(defun l ()
  (load "chap13"))

(defun bad-function ()
  (error 'foo))

(define-condition foo () ()
  (:report (lambda (condition stream)
             (princ "Stop FOOing around, numbskull!" stream))))

(handler-case (bad-function)
  (foo () "somebody signaled foo!")
  (bar () "somebody signaled bar!"))
