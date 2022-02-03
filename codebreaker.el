(require 'dash)

;; some constants
(setq cb/color-pegs '( ("R" . "red") ("G" . "green") ("Y" . "yellow") ("B" . "cyan") ("W" . "white") ("P" . "violet")))
(setq cb/puzzle-size 4)

(setq cb/HEADER "
                       +-+-+-+-+-+-+-+-+-+-+-+
                       |c|0|d|e|8|r|3|a|k|e|r|
                       +-+-+-+-+-+-+-+-+-+-+-+ 
                       
Welcome to c0de8r3aker, the game where you try to guess the hidden code,
consisting of four pegs colored (R)ed, (G)reen, (Y)ellow, (B)lue, (P)urple
or (W)hite. Enter any combination of the letters RGYBPW and the game will 
tell you how many you guessed correctly, and how many you got the color right
but the position wrong.

Good luck!
"
      )

;; I need this function because emacs-lisp `remove` removes all copies of member
(defun cb/remove (member l)
  "Return a copy of L where one instance of MEMBER has been removed."
  (cond ( (not l) '())
	( (equal member (car l)) (cdr l))
	( t (cons (car l) (cb/remove member (cdr l))))))

(defun cb/generate-list (size candidates)
  "Generate a list of size SIZE from elements in CANDIDATES."
  (if (equal 0 size) '()
    (cons (car (seq-random-elt candidates)) (cb/generate-list (- size 1) candidates))))

(defun cb/count-white-r (gl-short sl-short)
  (let ( (first (car gl-short))
	 (rest (cdr gl-short)))
    (cond ( (not first) 0)
	  ( (member first sl-short) (+ 1 (cb/count-white-r rest (cb/remove first sl-short))) )
	  ( t (cb/count-white-r rest sl-short)))))

;; todo: revisit this function. As is it's a very procedural implementation.
(defun cb/count-pegs (guess solution)
  "Return a cons of (black . white) pegs for the GUESS with respect to the SOLUTION."
  ( let ( (matches 0)
	  (guess-extra '())
	  (sol-extra '()))
    (dotimes (n (length guess))
      (if (equal (nth n guess) (nth n solution))
	  (setq matches (+ 1 matches))
	(progn
	  (setq guess-extra (cons (nth n guess)  guess-extra))
	  (setq sol-extra (cons (nth n solution) sol-extra)))))
    (cons matches (cb/count-white-r guess-extra sol-extra))))

  (defun cb/input ()
  "Waits for user to input guess and return it as list of chars"
  (let ( (input (upcase (read-string "Guess[WPBYRG]: "))))
    (cdr (split-string input ""))))

(defun cb/play-round (solution)
  "Play one round of the game given SOLUTION and returns t if the puzzle has been solved."
  (let* ( (guess (cb/input))
	  (pegs (cb/count-pegs guess solution)))
    (dolist (el guess)
      (insert (propertize el 'font-lock-face (list :foreground (cdr (assoc el cb/color-pegs))))))
    (insert " .... " (number-to-string (car pegs)) "." (number-to-string (cdr pegs)) "\n")
    (= 4 (car pegs))))

(defun cb/play-game ()
  "Play a game of code breaker."
  (interactive)
  (let ( (solution (cb/generate-list cb/puzzle-size cb/color-pegs))
	 (count 1))
    (switch-to-buffer "*c0de8r3aker*")
    (erase-buffer)
    (insert cb/HEADER)
    (insert "\n--------\n")
    (while (not (cb/play-round solution))
      (setq count (+ count 1)))
    (insert "\nCongratulations! You found a solution in " (number-to-string count) " tries.\n")))


