extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
    bbcode_text = "[center]Score:\n" + str(Globals.score)
    
func increaseScore(score):
    Globals.score  += score
    bbcode_text = "[center]Score:\n" + str(Globals.score)
