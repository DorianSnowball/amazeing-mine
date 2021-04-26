extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    var minutes = Globals.end_time / 60
    var seconds = Globals.end_time % 60
    bbcode_text = "[center]Elapsed Time:\n %02d : %02d" % [minutes, seconds]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
