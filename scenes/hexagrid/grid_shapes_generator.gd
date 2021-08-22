static func hexagon(radius : int) -> PoolVector3Array:
	var cells : PoolVector3Array = PoolVector3Array()
	for q in range(-radius, radius + 1):
		var r1 : int = int(max(-radius, -q - radius))
		var r2 : int = int(min(radius, -q + radius))
		for r in range(r1, r2 + 1):
			cells.push_back(Vector3(q, -q-r, r))
    
	return cells

static func parallelogram(q1 : int, q2 : int, r1 : int, r2 : int) -> PoolVector3Array:
	var cells : PoolVector3Array = PoolVector3Array()
	for q in range(q1, q2 + 1):
		for r in range(r1, r2 + 1):
			cells.push_back(Vector3(q, -q-r, r))

	return cells

static func rectangle(width : int, height : int) -> PoolVector3Array:
	var cells : PoolVector3Array = PoolVector3Array()
	for r in height:
		var r_offset : int = r >> 1
		for q in range(-r_offset, width - r_offset):
			cells.push_back(Vector3(q, -q-r, r))

	return cells

static func triangles(size : int) -> PoolVector3Array:
	var cells : PoolVector3Array = PoolVector3Array()
	for q in range(size):
		for r in range(size - q):
			cells.push_back(Vector3(q, -q-r, r))

	return cells
