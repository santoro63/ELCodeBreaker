(require 'dash)
(require 'cl)

;; some constants
(setq color-pegs '("R" "G" "Y" "B" "W" "P"))
(setq puzzle-size 4)
      
(defun zip (ar1 ar2)
  (mapcar* #'cons ar1 ar2))

(defun cons-match (c)
  "Return true if the two parts of the cons cell C are equal."
  (equal (car c) (cdr c)))

(defun generate-list (size candidates)
  "Generate a list of size SIZE from elements in CANDIDATES."
  (if (equal 0 size) '()
    (cons (nth (random 6) candidates) (generate-list (- size 1) candidates))))

(defun count-black (guess solution)
  "Return a count of how many pieces in the guess match the solution in color and notation."
  (let (
	(matched (-filter #'cons-match (zip guess solution))))
    (length matched)))
  
(defun count-white (guess solution)
  (let ( (unmatched (-filter (lambda (x) (not (cons-match x))) (zip guess solution))) )
    (count-xx (-map #'car unmatched) (-map #'cdr unmatched))
    ))

(defun count-xx (l1 l2)
  (cond ( (not l1) 0)
	( (member (car l1) l2) (+ 1 (count-xx (cdr l1) (remove (car l1) l2))))
	( t (count-xx (cdr l1) l2))))


(defun play-round (solution)
  "Play one round of the game given SOLUTION and returns t if the puzzle has been solved."
  (let* ( (guess
	   (read-string ": "))
	  (b    (count-black guess solution))
	  (w    (count-white guess solution))
	  )
    (insert guess " .... " (number-to-string b) "." (number-to-string w) "\n")
    (= 4 b)))


(defun play-game ()
  "Play a game of Mastermind"
  (let ( (solution (mapconcat #'identity (generate-list puzzle-size color-pegs) ""))
	 (count 1))
    (insert "\nSolution: " solution "\n\n")
    (while (not (play-round solution))
      (setq count (+ count 1)))
    (insert "Found a solution with " (number-to-string count) " tries.\n")))


