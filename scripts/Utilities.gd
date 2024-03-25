extends Node

func smooth_interp(v):
	return v * v * (3 - 2 * v)
