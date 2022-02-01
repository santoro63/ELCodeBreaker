;; unit tests for codebreaker

;; setup & fixtures

(package-initialize) ;; needed so (require 'dash) works
(load-file "./codebreaker.el")

;; tests

(ert-deftest test-cons-match ()
  (should (cb/cons-match '( 1 . 1)))
  (should (not (cb/cons-match '(1 . 2)))))

(ert-deftest test-count-black ()
  (should (equal 0 (cb/count-black "RRRB" "BBBR")))
  (should (equal 1 (cb/count-black "RRRB" "RBBG")))
  (should (equal 1 (cb/count-black "RRRB" "RGBR"))))

(ert-deftest test-count-white ()
  (should (equal 0 (cb/count-white "RRRB" "GGGY")))
  (should (equal 2 (cb/count-white "RRRB" "BBBR"))))

(ert-deftest test-cb-remove ()
  (should (equal '(1 3 2) (cb/remove 2 '(1 2 3 2))))
  (should (equal '(1 2 2) (cb/remove 3 '(1 2 3 2))))
  (should (equal '(1 2 3) (cb/remove 4 '(1 2 3)))))


;; run all defined tests
(ert-run-tests-batch)
