(defun l ()
  (load "format"))

(format t "PI can be estimated as ~,4f" 3.141593)
(fresh-line)
(format t "PI can be esttmated as ~,4f" pi)
(fresh-line)
(format t "Percentages are ~,,2f percent better than fractions" 0.77)
(fresh-line)
(format t "I wish I had ~$ dollars in my bank account." 10000000.2)
(fresh-line)


;;-----------------------------
;; テキストを揃える
;;-----------------------------
(defun random-animal ()
  (nth (random 5) '("dog" "tick" "tiger" "walrus" "kangaroo")))

(loop repeat 10
      do (format t "~5t~a ~15t~a ~25t~a~%"
                 (random-animal)
                 (random-animal)
                 (random-animal)))

(loop repeat 10
      do (format t "~30<~a~;~a~;a~a~>~%"
                 (random-animal)
                 (random-animal)
                 (random-animal)))

(loop repeat 10
      do (format t "~30:@<~a~>~%"
                 (random-animal)))

(loop repeat 10
      do (format t "~30:@<~a~;~a~;~a~>~%"
                 (random-animal)
                 (random-animal)
                 (random-animal)))

(loop repeat 10
      do (format t "~10:@<~a~>~10:@<~a~>~10:@<~a~>~%"
                 (random-animal)
                 (random-animal)
                 (random-animal)))

(defparameter *animals* (loop repeat 10 collect (random-animal)))
(format t "~{I see a ~a! ~}" *animals*)

(format t "~{I see a ~a... or was it a ~a?~%~}" *animals*)

(format t "|~{~<|~%|~,33:;~2d ~>~}|" (loop for x below 100 collect x))
