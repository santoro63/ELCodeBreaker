(require 'dash)
(require 'cl)

;; some constants
(setq cb/color-pegs '("R" "G" "Y" "B" "W" "P"))
(setq cb/puzzle-size 4)
      
(defun cb/zip (ar1 ar2)
  (mapcar* #'cons ar1 ar2))

;; I need this function because emacs-lisp `remove` removes all copies of member
(defun cb/remove (member l)
  "Return a copy of L where one instance of MEMBER has been removed."
  (cond ( (not l) '())
	( (equal member (car l)) (cdr l))
	( t (cons (car l) (cb/remove member (cdr l))))))

(defun cb/cons-match (c)
  "Return true if the two parts of the cons cell C are equal."
  (equal (car c) (cdr c)))

(defun cb/generate-list (size candidates)
  "Generate a list of size SIZE from elements in CANDIDATES."
  (if (equal 0 size) '()
    (cons (nth (random 6) candidates) (cb/generate-list (- size 1) candidates))))

(defun cb/count-black (guess solution)
  "Return a count of how many pieces in the guess match the solution in color and notation."
  (let (
	(matched (-filter #'cb/cons-match (cb/zip guess solution))))
    (length matched)))
  
(defun cb/count-white (guess solution)
  (let ( (unmatched (-filter (lambda (x) (not (cb/cons-match x))) (cb/zip guess solution))) )
    (cb/count-xx (-map #'car unmatched) (-map #'cdr unmatched))
    ))

(defun cb/count-xx (l1 l2)
  "Helper counting function for counting whites."
  (cond ( (not l1) 0)
	( (member (car l1) l2) (+ 1 (cb/count-xx (cdr l1) (cb/remove (car l1) l2))))
	( t (cb/count-xx (cdr l1) l2))))


(defun cb/play-round (solution)
  "Play one round of the game given SOLUTION and returns t if the puzzle has been solved."
  (let* ( (guess
	   (read-string ": "))
	  (b    (cb/count-black guess solution))
	  (w    (cb/count-white guess solution))
	  )
    (insert guess " .... " (number-to-string b) "." (number-to-string w) "\n")
    (= 4 b)))


(defun cb/play-game ()
  "Play a game of Mastermind."
  (interactive)
  (let ( (solution (mapconcat #'identity (cb/generate-list cb/puzzle-size cb/color-pegs) ""))
	 (count 1))
    (switch-to-buffer "*mastermind*")
    (insert "\n--------\n")
    (while (not (cb/play-round solution))
      (setq count (+ count 1)))
    (insert "Found a solution with " (number-to-string count) " tries.\n")))


