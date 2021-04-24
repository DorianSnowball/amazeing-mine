extends Node2D

var tile_tube = load("res://Tile_Tube.tscn")
var tile_corner = load("res://Tile_Corner.tscn")
var tile_end_piece = load("res://Tile_End_Piece.tscn")
var tile_T_piece = load("res://Tile_T_Piece.tscn")
var tile_intersection = load("res://Tile_Intersection.tscn")

var tile_list = [tile_tube, tile_corner, tile_end_piece, tile_T_piece, tile_intersection]

# Declare member variables here. Examples:
var fieldsize_width : int = 15
var fieldsize_height : int = 5

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
    
            
    
func drawField():
    tile_list.shuffle()
    var i = 0
    var j = 0
    $".".get_children().clear()
    for row in field:
        for node in row:
            var tile : KinematicBody2D = tile_list[randi() % tile_list.size()].instance()
            tile.position = Vector2(j*192+96,i*192+96)
            
            if randi() % 2 == 1:
                tile.scale.y *= -1
            
            if randi() % 2 == 1:
                tile.scale.x *= -1
            
            tile.rotate((randi() % 4)* 1.5707963268)
            
            
            $".".add_child(tile)
            j+=1
        i+=1
        j=0
    
func spawnDwarf():
    var dwarf = load("res://Dwarf.tscn").instance()
    dwarf.position = Vector2(32, 32)
    $".".add_child(dwarf)
    #for row in field:
        #for node in row:
        #	#var sprite = $Tile_Corner
        #	var sprite = Sprite.new()
        #	sprite.texture = load(getTileTextureById(node))
        #	sprite.position = Vector2(j*64+32,i*64+32)
        #	
        #	$".".add_child(sprite)
        #	j+=1
        #i+=1
        #j=0

func getTileTextureById(id):
    return "res://Sprites/tile"+str(id)+".png"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
