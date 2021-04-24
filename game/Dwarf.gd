extends KinematicBody2D

# score
var depth : int = 0

# environment variables
var speed : int = 200
var jumpforce : int = 300
var gravity : int = 800

var velocity : Vector2 = Vector2()

#var sprite : Sprite = $Sprite
onready var sprite : Sprite = get_node("Sprite")

func _physics_process(delta):
    
    velocity.x = 0
    
    # movement input here
    if Input.is_action_pressed("move_left"):
        velocity.x -= speed
    if Input.is_action_pressed("move_right"):
        velocity.x += speed
    
    # applying the velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
    # gravity
    velocity.y += gravity * delta
    
    # jump input
    if Input.is_action_just_pressed("jümp") and is_on_floor():
        velocity.y -= jumpforce
        #sprite.flip_v = true
        #yield(get_tree().create_timer(0.6),"timeout")
        #sprite.flip_v = false
        if velocity.x < 0:
            for x in range(30): #16
                sprite.rotation_degrees += 360/30  #22.5
                yield(get_tree().create_timer(0.6/30),"timeout")
        elif velocity.x >= 0:
            for x in range(30): #16
                sprite.rotation_degrees -= 360/30  #22.5
                yield(get_tree().create_timer(0.6/30),"timeout")
    
    # sprite direction
    if velocity.x < 0:
        sprite.flip_h = false
    elif velocity.x > 0:
        sprite.flip_h = true
        

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
