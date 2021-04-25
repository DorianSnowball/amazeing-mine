extends RichTextLabel

var items = 0

func _ready():
    bbcode_text = "[center]Items in Inventory:\n" + str(items)
    
func modify_items(positive):
    if positive:
        items += 1
    else:
        items -= 1
    bbcode_text = "[center]Items in Inventory:\n" + str(items)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
