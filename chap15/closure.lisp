(defun l ()
  (load "closure"))

(defparameter *foo1* (lambda ()
                      5))

(defparameter *foo2* (let ((x 5))
                       (lambda ()
                         x)))

(let ((line-number 0))
  (defun my-print (x)
    (print line-number)
    (print x)
    (incf line-number)
    nil))


