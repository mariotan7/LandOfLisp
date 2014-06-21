(defun l ()
    (load "if_when_unless_cond"))

(defparameter *odd-number*  nil)
(defparameter *even-number* nil)

(defun test-if (num)
  (if (oddp num)
    'odd-number
    'even-number))

(defun test-oddp-when (num)
  (when (oddp num)
    (setf *odd-number* t)
    'odd-number))

(defun test-oddp-unless (num)
  (unless (oddp num)
    (setf *even-number* t)
    'even-number))

(defvar *arch-enemy* nil)
(defun pudding-eater (person)
  (cond ((eq person 'henry) (setf *arch-enemy* 'stupid-lisp-alian)
                            '(curse you lisp alien - you ate my pudding))
        ((eq person 'johny) (setf *arch-enemy* 'useless-old-johnny)
                            '(i hope you choked on my pudding johnny))
        (t                  '(why you eat my pudding stranger ?))))
