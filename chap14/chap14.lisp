(defun l ()
  (load "chap14"))

(defparameter *my-list* '(4 7 2 3))

(defun not-lisper ()
  (loop for n below (length *my-list*)
        do (setf (nth n *my-list*) (+ (nth n *my-list*) 2))))

(defun lisp-beginner ()
  (add-two *my-list*))

(defun add-two (list)
  (when list
    (cons (+ 2 (car list)) (add-two (cdr list)))))

(defun lisper ()
  (mapcar (lambda (x)
            (+ x 2))
          *my-list*))
