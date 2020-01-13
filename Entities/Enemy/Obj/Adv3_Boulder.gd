extends EnemyCore

const DIRECTION_LEFT = -1
const DIRECTION_RIGHT = 1

export var speed = 60
export var bounce_set_vel_y = -120

onready var pf_bhv = $PlatformBehavior

var current_dir = -1

func _ready():
	pf_bhv.WALK_SPEED = speed
	
	if player != null:
		if player.global_position.x > global_position.x:
			pf_bhv.simulate_walk_right = true
			pf_bhv.simulate_walk_left = false
			current_dir = DIRECTION_RIGHT
		else:
			pf_bhv.simulate_walk_right = false
			pf_bhv.simulate_walk_left = true
			current_dir = DIRECTION_LEFT

func change_direction():
	match current_dir:
		DIRECTION_RIGHT:
			pf_bhv.simulate_walk_right = false
			pf_bhv.simulate_walk_left = true
			current_dir = DIRECTION_LEFT
		DIRECTION_LEFT:
			pf_bhv.simulate_walk_right = true
			pf_bhv.simulate_walk_left = false
			current_dir = DIRECTION_RIGHT

var flameburst_fireball = preload("res://Entities/Enemy/Obj/MM6_FlameBurstFireball.tscn")
func _on_PlatformBehavior_landed():
	pf_bhv.velocity.y = bounce_set_vel_y
	FJ_AudioManager.sfx_combat_boulder.play()
	
	var fireball = flameburst_fireball.instance()
	get_parent().add_child(fireball)
	fireball.global_position = global_position
	fireball.bullet_behavior.angle_in_degrees = 90
	fireball.get_node("SpriteMain/Sprite/PaletteSprite").primary_sprite.modulate = NESColorPalette.LIGHTSALMON4
	fireball.get_node("SpriteMain/Sprite/PaletteSprite").second_sprite.modulate = NESColorPalette.TOMATO3
	fireball.get_node("SpriteMain/Sprite/PaletteSprite").outline_sprite.modulate = NESColorPalette.BLACK1


func _on_PlatformBehavior_by_wall():
	change_direction()


func _on_PlatformBehavior_collided(kinematic_collision_2d):
	if kinematic_collision_2d is KinematicCollision2D:
		var collider = kinematic_collision_2d.get_collider()
		
		#If landed on death spike that's lava.
		if collider is DeathSpike:
			if collider.is_lava:
				current_hp = 0
				check_for_death()
			
