extends Panel


func spawnAnimation():
    var dwarf = $"Dwarf"
    while not dwarf.is_on_floor():
        yield(get_tree().create_timer(.1),"timeout")
    
    dwarf._animated_sprite.play("landing2")
    yield(get_tree().create_timer(.3),"timeout")
    while dwarf._animated_sprite.frame != 0:
        yield(get_tree().create_timer(.01),"timeout")
    dwarf._animated_sprite.stop()
    
    dwarf.velocity.x = -20
    dwarf._animated_sprite.flip_h = true
    dwarf._animated_sprite.play("walk")
    yield(get_tree().create_timer(1.2),"timeout")
    
    dwarf.velocity.x = 0
    dwarf._animated_sprite.play("idle")
    yield(get_tree().create_timer(0.8),"timeout")
    
    dwarf.velocity.x = 20
    dwarf._animated_sprite.flip_h = false
    dwarf._animated_sprite.play("walk")
    yield(get_tree().create_timer(2.5),"timeout")
    
    dwarf.velocity.x = 0
    dwarf._animated_sprite.play("idle")
    
    dwarf._speech_sprite.frame = 1
    yield(get_tree().create_timer(1.5),"timeout")
    dwarf._speech_sprite.frame = 0
    #dwarf.in_spawn_animation = false

func _ready():    
    spawnAnimation()
