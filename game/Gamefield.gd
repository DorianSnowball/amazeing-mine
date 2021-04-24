extends Node2D


# Declare member variables here. Examples:
var fieldsize_width = 5
var fieldsize_height = 5

var field = []


# Called when the node enters the scene tree for the first time.
func _ready():
    for x in range(fieldsize_width):
        field.append([])
        field[x]=[]        
        for y in range(fieldsize_height):
            field[x].append([])
            field[x][y]=0
    drawField()
    insertCol(true,2,1)
    yield(get_tree().create_timer(2.0),"timeout")
    drawField()
    insertCol(false,3,1)
    insertCol(true,2,0)
    yield(get_tree().create_timer(2.0),"timeout")
    drawField()
    pass # Replace with function body.

func insertRow(left, row, tile):
    row = field[row]
    if left:
        row.push_front(tile)
        row.pop_back()
    else:
        row.push_back(tile)
        row.pop_front()
        
func insertCol(top, col, tile):
    var row = [tile]
    for i in field:
        if top:
            row.push_back(i[col])
        else:
            row.push_front(i[col])
    
    if top:
        row.pop_back()
    else:
        row.pop_front()
    
    var j = 0
    for i in field:
        i[col] = row[j]
        j+=1
    
            
    
func drawField():
    var i = 0
    var j = 0
    $".".get_children().clear()
    for row in field:
        for node in row:
            var sprite = Sprite.new()
            sprite.texture = load(getTileTextureById(node))
            sprite.position = Vector2(j*64+32,i*64+32)
            
            $".".add_child(sprite)
            j+=1
        i+=1
        j=0

func getTileTextureById(id):
    return "res://tile"+str(id)+".png"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
