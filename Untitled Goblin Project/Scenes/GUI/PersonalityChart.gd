extends Control

var values = [13, 25, 17, 8]  # List of numbers to make into a chart
var size = 100  # Adjust this value according to your UI
var chart = null

func _ready():
	chart = get_node("Polygon2D")
	update_chart()

func update_chart():
	var pool = PoolVector2Array()  # Soon to be list of positions
	var angle = deg2rad(-180)  # Starting angle for the first point
	var angle_offset = (2*PI)/(len(values))  # This is the magic for getting radial positions
	for i in range(len(values)):
		var point = Vector2(values[i] * size / 100, 0).rotated(angle)  # This rotates the current point in 2d space
		pool.append(point + Vector2(size, size))  # Add it to the list and shift the origin to the center
		angle += angle_offset  # Update the angle for the next point
	chart.polygon = pool  # Here's the polygon
