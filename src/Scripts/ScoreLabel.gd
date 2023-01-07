extends Label

var score = 0

func increment_score():
	score += 1
	text = "Forest raked: %s" % score
