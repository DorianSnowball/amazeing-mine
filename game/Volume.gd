extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _on_sfx_value_changed(value):
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value/100))
    $"sfx_value_label".bbcode_text = str(value)
    $"/root/Globals".sound_float = value


func _on_music_value_changed(value):
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value/100))
    $"music_value_label".bbcode_text = str(value)
    $"/root/Globals".music_float = value

# Called when the node enters the scene tree for the first time.
func _ready():
    if $"/root/Globals".music_float == -1:
        $"music".value = 100
    else:
        $"music".value = $"/root/Globals".music_float
    
    if $"/root/Globals".sound_float == -1:
        $"sfx".value = 100
    else:
        $"sfx".value = $"/root/Globals".sound_float
    
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
