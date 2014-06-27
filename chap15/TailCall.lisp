(defun l ()
  (load "TailCall"))

(defun my-length-0 (lst)
  (if lst
    (1+ (my-length (cdr lst)))
    0))

(defun my-length-1 (lst)
  (labels ((f (lst acc)
              (if lst
                (f (cdr lst) (1+ acc))
                acc)))
    (f lst 0)))


(defparameter *biglist* (loop for i below 100000 collect 'x))
