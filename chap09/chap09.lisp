(defun l ()
    (load "chap09"))

(defparameter *drink-order* (make-hash-table))
(setf (gethash 'bill *drink-order*) 'double-espresso)
(setf (gethash 'lisa *drink-order*) 'small-drip-coffee)
(setf (gethash 'john *drink-order*) 'medium-latte)

(defun foo ()
  (values 3 7))

(defstruct person
           name
           age
           waist-size
           favorite-color)

(defparameter *bob* (make-person :name "Bob"
                                 :age  35
                                 :waist-size 32
                                 :favorite-color "blue"))

(defun sum (lst)
  (reduce #'+ lst))

;;(defun add (a b)
;;  (cond ((and (numberp a) (numberp b)) (+ a b))
;;        ((and (listp a) (listp b)) (append a b))))

(defmethod add ((a number) (b number))
  (+ a b))

(defmethod add ((a list) (b list))
  (append a b))
