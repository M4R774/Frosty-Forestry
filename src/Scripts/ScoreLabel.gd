extends Label

var score = 0

func increment_score():
	score += 1
	text = "Trees chopped: %s" % score

#	if score % 5 == 0:
#		$"/root/Main/ParallaxBackground".change_level()
