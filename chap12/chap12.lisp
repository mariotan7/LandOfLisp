(defun l ()
    (load "chap12"))

;; 出力ストリーム
(output-stream-p *standard-output*)
(write-char #\x *standard-output*)

;; 入力ストリーム
(input-stream-p *standard-input*)
;;(read-char *standard-input*)

;;------------------------------
;; ファイルの読み書き
;;------------------------------
(with-open-file (my-stream "data.txt" :direction :output)
  (print "my data" my-stream))

;;(with-open-file (my-stream "data.txt" :direction :input)
;;  (read my-stream))

(defun write-animal-noises ()
  (let ((animal-noises '((dog . woof)
                         (cat . meow))))
    (with-open-file (my-stream "animal-noises.txt" :direction :output)
      (print animal-noises my-stream))))

(defun read-animal-noises ()
  (with-open-file (my-stream "animal-noises.txt" :direction :input)
    (read my-stream)))

(defun if-exists-error-data-file ()
  (with-open-file (my-stream "data.txt" :direction :output :if-exists :error)
    (print "my data" my-stream)))

(defun if-exists-supersede-data-file ()
  (with-open-file (my-stream "data.txt" :direction :output :if-exists :supersede)
    (print "my data" my-stream)))


