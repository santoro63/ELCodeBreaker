.PHONY: test clean

test : .test.flag

clean:
	rm .test.flag

# runs unit tests
.test.flag : codebreaker.el tests.el
	emacs --script tests.el && touch .test.flag
