class_name ScrollingTextureRect
extends TextureRect

# velocity at which the texture scrolls (pixels/second)
export var scroll_velocity: Vector2 = Vector2.ZERO
export var scrolling: bool = true

# tracks offset of the texture
var progress: Vector2 = Vector2.ZERO
onready var init_pos = rect_position
onready var scroll_dist = 0.75 * rect_size.y

func _process(delta):
	if texture == null or !scrolling: return
	
	# add movement
	rect_position += scroll_velocity * delta
	progress += scroll_velocity * delta
	
	# check if we moved over the entire map
	while abs(progress.y) >= scroll_dist:
		progress.y -= scroll_dist * sign(scroll_velocity.y)
		rect_position.y -= scroll_dist * sign(scroll_velocity.y)

func _on_PlayButton_pressed():
	progress.y = 0
	rect_position = init_pos
	scroll_velocity.y = 150

func _on_PlayerSpawner_you_died():
	scroll_velocity.y = 0
