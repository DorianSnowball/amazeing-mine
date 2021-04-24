extends Node2D

var tile_tube = load("res://Tile_Tube.tscn")
var tile_corner = load("res://Tile_Corner.tscn")
var tile_end_piece = load("res://Tile_End_Piece.tscn")
var tile_T_piece = load("res://Tile_T_Piece.tscn")
var tile_intersection = load("res://Tile_Intersection.tscn")

var arrow_button = load("res://Arrow_Button.tscn")

var tile_list = [tile_tube, tile_corner, tile_end_piece, tile_T_piece, tile_intersection]

# Declare member variables here. Examples:
var fieldsize_width : int = 5
var fieldsize_height : int = 5

var tile_scaling = 2
var tile_basesize = 64

var field : = []




# Called when the node enters the scene tree for the first time.
func _ready():
    # init 2d array
    for x in range(fieldsize_height):
        field.append([])
        field[x]=[]        
        for y in range(fieldsize_width):
            field[x].append([])
            field[x][y]=0
            
    # draw field and test insert functions
    generateRandomField()
    drawField()
    spawnDwarf()
    #insertCol(true,2,1)
    #yield(get_tree().create_timer(2.0),"timeout")
    #drawField()
    #insertCol(false,3,1)
    #insertCol(true,2,0)
    #yield(get_tree().create_timer(2.0),"timeout")
    #drawField()

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
    
func generateRandomField():
    randomize()
    tile_list.shuffle()
    var i = 0
    var j = 0
    for row in field:
        for node in row:
           
            
            field[i][j] = getRandomTile()
            j+=1
        i+=1
        j=0

func getRandomTile():
    var tile : KinematicBody2D = tile_list[randi() % tile_list.size()].instance()
    tile.scale = Vector2(tile_scaling, tile_scaling)
    
    if randi() % 2 == 1:
        tile.scale.y *= -1
    
    if randi() % 2 == 1:
        tile.scale.x *= -1
    
    tile.rotate((randi() % 4)* 1.5707963268)
    return tile
    
func drawField():
    var i = 0
    var j = 0
    $".".get_children().clear()
    
    
    # draw arrows
    for x in range(fieldsize_width + 2):
        for y in range(fieldsize_height + 2):
            var arrow: Node2D = arrow_button.instance()
            var button: TextureButton = arrow.get_child(0)
            button.connect("pressed", self, "arrow_pressed", [Vector2(x,y)])

            arrow.position = Vector2(x*(tile_basesize*tile_scaling), y*(tile_basesize*tile_scaling))
            if x==0 and y in range(1,fieldsize_height+1): # left col    
                arrow.rotation_degrees = -90
                arrow.position.x += tile_basesize / 2
                $".".add_child(arrow)
            if y == 0 and x in range(1,fieldsize_width+1): # top row
                arrow.position.y += tile_basesize / 2
                $".".add_child(arrow)
            if x == fieldsize_width+1 and y in range(1, fieldsize_height+1): # right col
                arrow.rotation_degrees = 90
                arrow.position.x -= tile_basesize / 2
                $".".add_child(arrow)
            if y == fieldsize_height+1 and x in range(1,fieldsize_width+1): # bot row
                arrow.rotation_degrees = 180
                arrow.position.y -= tile_basesize / 2
                $".".add_child(arrow)
                
    # draw tiles
    for row in field:
        for node in row:

            node.position = Vector2((j+0.5)*(tile_basesize*tile_scaling)+tile_basesize,(i+0.5)*(tile_basesize*tile_scaling)+tile_basesize)
            
            $".".add_child(node)
            j+=1
        i+=1
        j=0
    
func spawnDwarf():
    var dwarf = load("res://Dwarf.tscn").instance()
    dwarf.position = Vector2(32+(tile_basesize*tile_scaling), 32+(tile_basesize*tile_scaling))
    print(getCord(dwarf.position.x, dwarf.position.y))
    $".".add_child(dwarf)

func getRow(y):
    return int(y-tile_basesize) / (tile_basesize * tile_scaling)
    
func getCol(x):
    return int(x-tile_basesize) / (tile_basesize * tile_scaling)
    
func getCord(x,y):
    return Vector2(getCol(x), getRow(y))
    
func arrow_pressed(pos):
    if pos.x == 0: # left row button pressed
        print("left row")
        
    
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
