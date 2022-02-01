(require 'dash)
(require 'cl)

;; some constants
(setq mm/color-pegs '("R" "G" "Y" "B" "W" "P"))
(setq mm/puzzle-size 4)
      
(defun mm/zip (ar1 ar2)
  (mapcar* #'cons ar1 ar2))

;; I need this function because emacs-lisp `remove` removes all copies of member
(defun mm/remove (member l)
  "Return a copy of L where one instance of MEMBER has been removed."
  (cond ( (not l) '())
	( (equal member (car l)) (cdr l))
	( t (cons (car l) (mm/remove member (cdr l))))))

(defun mm/cons-match (c)
  "Return true if the two parts of the cons cell C are equal."
  (equal (car c) (cdr c)))

(defun mm/generate-list (size candidates)
  "Generate a list of size SIZE from elements in CANDIDATES."
  (if (equal 0 size) '()
    (cons (nth (random 6) candidates) (mm/generate-list (- size 1) candidates))))

(defun mm/count-black (guess solution)
  "Return a count of how many pieces in the guess match the solution in color and notation."
  (let (
	(matched (-filter #'mm/cons-match (mm/zip guess solution))))
    (length matched)))
  
(defun mm/count-white (guess solution)
  (let ( (unmatched (-filter (lambda (x) (not (mm/cons-match x))) (mm/zip guess solution))) )
    (mm/count-xx (-map #'car unmatched) (-map #'cdr unmatched))
    ))

(defun mm/count-xx (l1 l2)
  "Helper counting function for counting whites."
  (cond ( (not l1) 0)
	( (member (car l1) l2) (+ 1 (mm/count-xx (cdr l1) (mm/remove (car l1) l2))))
	( t (mm/count-xx (cdr l1) l2))))


(defun mm/play-round (solution)
  "Play one round of the game given SOLUTION and returns t if the puzzle has been solved."
  (let* ( (guess
	   (read-string ": "))
	  (b    (mm/count-black guess solution))
	  (w    (mm/count-white guess solution))
	  )
    (insert guess " .... " (number-to-string b) "." (number-to-string w) "\n")
    (= 4 b)))


(defun mm/play-game ()
  "Play a game of Mastermind."
  (interactive)
  (let ( (solution (mapconcat #'identity (mm/generate-list mm/puzzle-size mm/color-pegs) ""))
	 (count 1))
    (switch-to-buffer "*mastermind*")
    (insert "\n--------\n")
    (while (not (mm/play-round solution))
      (setq count (+ count 1)))
    (insert "Found a solution with " (number-to-string count) " tries.\n")))


