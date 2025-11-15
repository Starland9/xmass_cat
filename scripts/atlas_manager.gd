extends Node

class FloorAtlas:
	var top_left : Vector2
	var rows : int = 3
	var cols : int = 3
	
	func top_center(): return Vector2(top_left.x + (cols / 2), top_left.y)
	func top_right(): return Vector2(top_left.x + cols - 1, top_left.y)
	
	func middle_left(): return Vector2(top_left.x, top_left.y + rows / 2)
	func middle_center(): return Vector2(top_center().x, middle_left().y)
	func middle_right(): return Vector2(top_right().x, middle_center().y)

	func bottom_left(): return Vector2(top_left.x, top_left.y + rows - 1)
	func bottom_center(): return Vector2(middle_center().x, bottom_left().y)
	func bottom_right(): return Vector2(middle_right().x, bottom_center().y)

class Floors:
	
	static func _gen_floor(top_left: Vector2, rows: int = 3, cols: int = 3) -> FloorAtlas:
		var atlas = FloorAtlas.new()
		atlas.top_left = top_left
		atlas.rows = rows
		atlas.cols = cols
		return atlas
	
	static var simple := _gen_floor(Vector2(0, 6), 2, 4)
	static var marroon := _gen_floor(Vector2(16, 4))
	static var marroon_black := _gen_floor(Vector2(16, 13))
	static var wall := _gen_floor(Vector2(8, 4), 2, 2)
	
	static var all : Array[FloorAtlas] = [
		simple, marroon, marroon_black, wall
	]
	
	
	
