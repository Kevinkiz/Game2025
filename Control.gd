extends Control

var score = 0

func _ready():
	$ClickButton.text = "Click me!"
	$ScoreLabel.text = "Score: %d" % score
	$ClickButton.pressed.connect(_on_ClickButton_pressed)

func _on_ClickButton_pressed():
	score += 1
	$ScoreLabel.text = "Score: %d" % score


