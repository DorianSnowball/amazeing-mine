extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var score = 0

func _ready():
    text = "Depth:\n" + str(score)+"m"
    
func increaseScore():
    score += 10
    text = "Depth:\n" + str(score)+"m"
