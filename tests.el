;; unit tests for codebreaker

;; setup & fixtures

(package-initialize) ;; needed so (require 'dash) works
(load-file "./codebreaker.el")


;; tests

(ert-deftest test-count-black ()
  (should (equal 0 (cb/count-black '("R" "R" "R" "B") '("B" "B" "B" "R"))))
  (should (equal 1 (cb/count-black '("R" "R" "R" "B") '("R" "B" "B" "G"))))
  (should (equal 1 (cb/count-black '("R" "R" "R" "B") '("R" "G" "B" "R")))))

(ert-deftest test-count-white ()
  (should (equal 0 (cb/count-white '("R" "R" "R" "B") '("G" "G" "G" "Y"))))
  (should (equal 2 (cb/count-white '("R" "R" "R" "B") '("B" "B" "B" "R")))))

(ert-deftest test-cb-remove ()
  (should (equal '(1 3 2) (cb/remove 2 '(1 2 3 2))))
  (should (equal '(1 2 2) (cb/remove 3 '(1 2 3 2))))
  (should (equal '(1 2 3) (cb/remove 4 '(1 2 3)))))


;; run all defined tests
(ert-run-tests-batch)
