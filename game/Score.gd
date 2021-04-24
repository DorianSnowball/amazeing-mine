extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var score = 0

func _ready():
    text = "Score:\n" + str(score)
    
func increaseScore():
    score += 10
    text = "Score:\n" + str(score)
