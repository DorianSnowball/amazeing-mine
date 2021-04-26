extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func _process(delta):
    var time_now = OS.get_unix_time()
    var elapsed = time_now - get_parent().get_child(0).start_time
    var minutes = elapsed / 60
    var seconds = elapsed % 60
    var str_elapsed = "[center]Elapsed Time:\n %02d : %02d" % [minutes, seconds]
    bbcode_text = str_elapsed
    Globals.end_time = elapsed

func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
