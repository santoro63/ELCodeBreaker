;; unit tests for codebreaker

;; setup & fixtures

(package-initialize) ;; needed so (require 'dash) works
(load-file "./codebreaker.el")


;; tests

(ert-deftest test-cb-remove ()
  (should (equal '(1 3 2) (cb/remove 2 '(1 2 3 2))))
  (should (equal '(1 2 2) (cb/remove 3 '(1 2 3 2))))
  (should (equal '(1 2 3) (cb/remove 4 '(1 2 3)))))

(ert-deftest test-count-pegs ()
  (should (equal '(0 . 2) (cb/count-pegs '("R" "R" "R" "B") '("B" "B" "B" "R"))))
  (should (equal '(1 . 1) (cb/count-pegs '("R" "R" "R" "B") '("R" "B" "B" "G"))))
  (should (equal '(1 . 2) (cb/count-pegs '("R" "R" "R" "B") '("R" "G" "B" "R")))))

;; run all defined tests
(ert-run-tests-batch)
