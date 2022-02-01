(require 'dash)

;; some constants
(setq cb/color-pegs '("R" "G" "Y" "B" "W" "P"))
(setq cb/puzzle-size 4)
      
;; I need this function because emacs-lisp `remove` removes all copies of member
(defun cb/remove (member l)
  "Return a copy of L where one instance of MEMBER has been removed."
  (cond ( (not l) '())
	( (equal member (car l)) (cdr l))
	( t (cons (car l) (cb/remove member (cdr l))))))

(defun cb/generate-list (size candidates)
  "Generate a list of size SIZE from elements in CANDIDATES."
  (if (equal 0 size) '()
    (cons (seq-random-elt candidates) (cb/generate-list (- size 1) candidates))))

(defun cb/count-black (guess solution)
  (cond ( (not guess) 0 )    ;; 0 if empty
	( (equal (car guess) (car solution)) (+ 1 (cb/count-black (cdr guess) (cdr solution)))) ;; add if they match
	( t (cb/count-black (cdr guess) (cdr solution))))) ;; if they do not match

(defun cb/count-white (guess solution)
    (cb/count-white-r (remove-equal guess solution) (remove-equal solution guess)))

(defun remove-equal (main-l other-l)
  (cond ( (not main-l) '() )
	( (equal (car main-l) (car other-l)) (remove-equal (cdr main-l) (cdr other-l)))
	( t (cons (car main-l) (remove-equal (cdr main-l) (cdr other-l))))))

(defun cb/count-white-r (gl-short sl-short)
  (let ( (first (car gl-short))
	 (rest (cdr gl-short)))
    (cond ( (not first) 0)
	  ( (member first sl-short) (+ 1 (cb/count-white-r rest (cb/remove first sl-short))) )
	  ( t (cb/count-white-r rest sl-short)))))

(defun cb/input ()
  "Waits for user to input guess and return it as list of chars"
  (let ( (input (read-string ": ")))
    (cdr (split-string input ""))))

(defun cb/play-round (solution)
  "Play one round of the game given SOLUTION and returns t if the puzzle has been solved."
  (let* ( (guess (cb/input))
	  (b    (cb/count-black guess solution))
	  (w    (cb/count-white guess solution))
	  )
    (insert (string-join guess "") " .... " (number-to-string b) "." (number-to-string w) "\n")
    (= 4 b)))


(defun cb/play-game ()
  "Play a game of code breaker."
  (interactive)
  (let ( (solution (cb/generate-list cb/puzzle-size cb/color-pegs))
	 (count 1))
    (switch-to-buffer "*mastermind*")
    (insert "\n--------\n")
    (while (not (cb/play-round solution))
      (setq count (+ count 1)))
    (insert "Found a solution with " (number-to-string count) " tries.\n")))


