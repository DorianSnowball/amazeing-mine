extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var score = 0

func _ready():
    bbcode_text = "[center]Depth:\n" + str(score)+"m"
    
func increaseScore():
    score += 10
    Globals.score  = score
    bbcode_text = "[center]Depth:\n" + str(score)+"m"
