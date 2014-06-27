(defun l ()
  (load "DoD"))

(defparameter *num-players* 2)
(defparameter *max-dice*    3)
(defparameter *board-size*  3)
(defparameter *board-hexnum* (* *board-size* *board-size*))

;;-----------------------------------
;; ゲーム盤の表現
;;-----------------------------------

;; ゲーム盤をリストから配列に変える
(defun board-array (lst)
  (make-array *board-hexnum* :initial-contents lst))

;; 配列で表現されたゲーム盤を生成する
;; 要素の順番はゲーム盤の順番
;;                 0                 1    ...
;; #( (プレーヤーNo. サイコロの数) (...) (...) )
;; #( (1 3) (0 2) (0 1) (0 2) )
(defun gen-board ()
  (board-array (loop for n below *board-hexnum*
                     collect (list (random *num-players*)
                                   (1+ (random *max-dice*))))))


;; プレーヤーNo.から文字への変換
(defun player-letter (n)
  (code-char (+ 97 n)))

;; ゲーム盤のコンソールへの出力
(defun draw-board (board)
  (loop for y below *board-size*
        do (progn (fresh-line)
                  (loop repeat (- *board-size* y)
                        do (princ " "))
                  (loop for x below *board-size*
                        for hex = (aref board (+ x (* *board-size* y)))
                        do (format t "~a-~a " (player-letter (first hex))
                                   (second hex))))))

;; for debug
;;(defparameter *test-board* (board-array (gen-board)))
;;(defparameter *test-board* #((0 3) (0 3) (1 3) (1 1)))
(defparameter *test-board* #((0 1) (1 1) (0 2) (1 1)))

;;-----------------------------------
;; ゲームツリーの作成
;;-----------------------------------

;; board     : 盤面の状態 #( (プレーヤーNo. サイコロの数) (...) (...) )
;; cur-player    : 現在の手番のプレーヤー Int
;; spare-dice: 現在の手番でプレーヤーがいくつサイコロを獲得したか Int
;; first-move: 現在の指し手が初めての指し手かどうか t or nil

(defun game-tree (board cur-player spare-dice first-move)
  (list cur-player
        board
        (add-passing-move board
                          cur-player
                          spare-dice
                          first-move
                          (attacking-moves board cur-player spare-dice))))

;; ゲーム木をメモ化する
(let ((old-game-tree (symbol-function 'game-tree))
      (previous (make-hash-table :test #'equalp)))
  (defun game-tree (&rest rest)
    (or (gethash rest previous)
        (setf (gethash rest previous) (apply old-game-tree rest)))))

;;-----------------------------------
;; 相手に手番を渡す
;;-----------------------------------
(defun add-passing-move (board player spare-dice first-move moves)
  (if first-move
    moves
    (cons (list nil
                (game-tree (add-new-dice board player (1- spare-dice))
                           (mod (1+ player) *num-players*)
                           0
                           t))
          moves)))

;;---------------------------------------------
;; 攻撃の手を計算する
;; 可能な攻撃の指し手をゲーム木に追加する関数
;;---------------------------------------------
;; *test-board* = #((1 3) (0 2) (0 1) (0 2))
;;
;; (attacking-moves *test-board* 1 0)
;; (( (0 1) (1 #((1 1) (1 2) (1 3) (1 2)) ((NIL (0 #((1 2) (1 2) (1 3) (1 2)) NIL)))) ))
;; ( mapcan (mapcan #'攻撃可能か 隣接セル=dst) (盤面全て=src) )
(defun attacking-moves (board cur-player spare-dice)
  (labels ((player (pos)
                   (car  (aref board pos)))
           (dice   (pos)
                   (cadr (aref board pos))))
    (mapcan (lambda (src)
              (when (eq (player src) cur-player)
                (mapcan (lambda (dst)
                          (when (and (not (eq (player dst) cur-player))
                                     (> (dice src) (dice dst)))
                            (list
                              (list (list src dst)
                                    (game-tree (board-attack board cur-player
                                                             src dst (dice src))
                                               cur-player
                                               (+ spare-dice (dice dst))
                                               nil)))))
                        (neighbors src))))
            (loop for n below *board-hexnum*
                  collect n))))

;;-----------------------------------
;; 隣接するマスを見つける
;;-----------------------------------
(defun neighbors (pos)
  (let ((up   (- pos *board-size*))
        (down (+ pos *board-size*)))
    (loop for p in (append (list up down)
                           (unless (zerop (mod pos *board-size*))
                             (list (1- up) (1- pos)))
                           (unless (zerop (mod (1+ pos) *board-size*))
                             (list (1+ pos) (1+ down))))
          when (and (>= p 0) (< p *board-hexnum*))
          collect p )))

;; neighbours関数をメモ化する
(let ((old-neighbours (symbol-function 'neighbors))
       (previous (make-hash-table)))
      (defun neighbours (pos)
        (or (gethash pos previous)
            (setf (gethash pos previous) (funcall old-neighbours pos)))))


;;-------------------------------------------------
;; 攻撃
;; srcからdstを攻撃した時に何が起きるかを計算する
;;-------------------------------------------------
(defun board-attack (board player src dst dice)
  (board-array (loop for pos from 0
                     for hex across board
                     collect (cond ((eq pos src) (list player      1    ))
                                   ((eq pos dst) (list player (1- dice) ))
                                   (t hex)))))

(defun test-board-attack (board)
  (loop for pos from 0
        for hex across board
        collect( cons pos hex)))

(defun test2-board-attack (board)
  (loop for hex across board
        collect hex))

;;-----------------------------------
;; 補給
;;-----------------------------------
;;(defun add-new-dice (board player spare-dice)
;;  (labels ((f (lst n)
;;              (cond ((null lst) nil)
;;                    ((zerop  n) lst)
;;                    (t (let ((cur-player (caar  lst))
;;                             (cur-dice   (cadar lst)))
;;                         (if (and (eq cur-player player    )
;;                                  (<  cur-dice   *max-dice*))
;;                           (cons (list cur-player (1+ cur-dice))
;;                                 (f (cdr lst) (1- n)))
;;                           (cons (car lst)
;;                                 (f (cdr lst) n))))))))
;;    (board-array (f (coerce board 'list) spare-dice))))

;; 末尾呼び出し最適化
(defun add-new-dice (board player spare-dice)
  (labels ((f (lst n acc)
              (cond ((zerop n ) (append (reverse acc) lst))
                    ((null lst) (reverse acc))
                    (t (let ((cur-player (caar  lst))
                             (cur-dice   (cadar lst)))
                         (if (and (eq cur-player player)
                                  (< cur-dice *max-dice*))
                           (f (cdr lst)
                              (1- n)
                              (cons (list cur-player (1+ cur-dice)) acc))
                           (f (cdr lst) n (cons (car lst) acc))))))))
    (board-array (f (coerce board 'list) spare-dice ()))))




;;-----------------------------------
;; 人間対人間でDoDをプレイする
;;-----------------------------------

;; メインループ
(defun play-vs-human (tree)
  (print-info tree)
  (if (caddr tree)
    (play-vs-human (handle-human tree))
    (announce-winner (cadr tree))))

;; ゲームの状態を表示する
(defun print-info (tree)
  (fresh-line)
  (format t "current player = ~a" (player-letter (car tree)))
  (draw-board (cadr tree)))

;; 人間のプレーヤーからの入力を処理する
(defun handle-human (tree)
  (fresh-line)
  (princ "choose your move:")
  (let ((moves (caddr tree)))
    (loop for move in moves
          for n from 1
          do (let ((action (car move)))
               (fresh-line)
               (format t "~a. " n)
               (if action
                 (format t "~a -> ~a" (car action) (cadr action))
                 (princ "end turn"))))
    (fresh-line)
    (cadr (nth (1- (read)) moves))))

;; 勝者を決定する
(defun winners (board)
  (let* ((tally (loop for hex across board
                      collect (car hex)))
         (totals (mapcar (lambda (player)
                           (cons player (count player tally)))
                         (remove-duplicates tally)))
         (best (apply #'max (mapcar #'cdr totals))))
    (mapcar #'car
            (remove-if (lambda (x)
                         (not (eq (cdr x) best)))
                       totals))))

(defun announce-winner (board)
  (fresh-line)
  (let ((w (winners board)))
    (if (> (length w) 1)
      (format t "The game is a tie between ~a" (mapcar #'player-letter w))
      (format t "The winner is ~a" (player-letter (car w))))))


;;-----------------------------------
;; ミニマックスをコードにする
;;-----------------------------------

;; ゲーム木のある節での点数を計算する
(defun rate-position (tree player)
  (let ((moves (caddr tree)))
    (if moves
      (apply (if (eq (car tree) player)
               #'max
               #'min)
             (get-ratings tree player))
      (let ((w (winners (cadr tree))))
        (if (member player w)
          (/ 1 (length w))
          0)))))

;; rate-position関数をメモ化する
(let ((old-rate-position (symbol-function 'rate-position))
      (previous (make-hash-table)))
  (defun rate-position (tree player)
    (let ((tab (gethash player previous)))
      (unless tab
        (setf tab (setf (gethash player previous) (make-hash-table))))
      (or (gethash tree tab)
          (setf (gethash tree tab)
                (funcall old-rate-position tree player))))))

;; 現在のゲーム木全ての枝にrate-positionをマップする
(defun get-ratings (tree player)
  (mapcar (lambda (move)
            (rate-position (cadr move) player))
          (caddr tree)))

;;-----------------------------------
;; AIプレーヤーを使うゲームループ
;;-----------------------------------
(defun handle-computer (tree)
  (let ((ratings (get-ratings tree (car tree))))
    (cadr (nth (position (apply #'max ratings) ratings) (caddr tree)))))

(defun play-vs-computer (tree)
  (print-info tree)
  (cond ((null  (caddr tree)) (announce-winner (cadr tree)))
        ((zerop (car   tree)) (play-vs-computer (handle-human tree)))
        (t (play-vs-computer (handle-computer tree)))))


