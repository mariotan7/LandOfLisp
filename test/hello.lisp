(defun say-hello ()
  (print "Please type your name:")
  (let ((name (read)))
    (print "Nice to meet you, ")
    (print name)))

(defun add-five ()
  (print "please enter a number:")
  (let ((num (read)))
    (print "When I add five I get")
    (print (+ num 5))))

(defun print-newline ()
  (progn (princ "This sentence will be interrupted")
         (princ #\newline)
         (princ "by an annoying newline character.")))

(defun say-hello2()
  (princ "Please tye your name:")
  (let ((name (read-line)))
    (princ "Nice to meet you, ")
    (princ name)))


