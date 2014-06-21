(defparameter *drink-order* '((bill . double-espresso)
                              (lisa . small-drip-coeffee)
                              (john . medium-latte)))

(defparameter *wizard-nodes* '((living-room (you are in the living-room.
                                          a wizard is snoring loudly on the couch.))
                        (garden      (you are in a beautiful garden.
                                          there is a well in front of you.))
                        (attic       (you are in the attic.
                                          there is a giant welding trch in the corner.))))

(defparameter *house* '((walls   (mortar (cement)
                                         (water)
                                         (sand))
                                 (bricks))
                        (windows (glass)
                                 (frame)
                                 (curtains))
                        (roof    (shingles)
                                 (chimney))))


(defparameter *wizard-edges* '((living-room (garden west door)
                                     (attic upstairs ladder))
                        (garden (living-room east door))
                        (attic  (living-room downstairs ladder))))

(defun ingredients (order)
  (mapcan (lambda (burger)
            (case burger
              (single (list 'patty))
              (double (list 'patty 'patty))
              (double-cheese (list 'patty 'patty 'cheese))))
          order))
