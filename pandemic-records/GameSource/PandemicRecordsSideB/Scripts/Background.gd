extends Control

# Node variables for easy access.
onready var _background_node := $TextureRect
onready var _border_node := $Border
#onready var _contents_node := $Contents
onready var _tween := $Tween

func _ready() -> void:
	# set minimum size based on the minimum size of the border
	_border_node.rect_min_size = _border_node.texture.get_size()
	rect_min_size = _border_node.rect_min_size
	_background_node.rect_min_size = rect_min_size * 2/3
	
	# set margins depending on the movement direction.
	var texture_size = _background_node.texture.get_size()
	
	if _background_node.scroll_velocity.x > 0:
		_background_node.margin_right = -texture_size.x
	elif _background_node.scroll_velocity.x < 0:
		_background_node.margin_left = texture_size.x

	if _background_node.scroll_velocity.y > 0:
		_background_node.margin_bottom = -texture_size.y
	elif _background_node.scroll_velocity.y < 0:
		_background_node.margin_top = texture_size.y
