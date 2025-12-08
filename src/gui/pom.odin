package main

import "core:time"
import rl "vendor:raylib"

main :: proc() {
    window := Window{"POMODIN", 800, 600, 60}
    rl.InitWindow(window.width, window.height, window.name)
    rl.SetTargetFPS(window.fps)
    defer rl.CloseWindow()

    countdown := true

    time_goal_mins := 1
    time_goal := time.tick_add(time.tick_now(), time.Minute * time.Duration(time_goal_mins))
    
    for !rl.WindowShouldClose() {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(GRUVBOX_GREY)

	draw_timer(window.width, window.height, time_goal)

	if countdown {
	    if time.tick_diff(time.tick_now(), time_goal) <= time.Duration(0) {
		countdown = false
		play_audio()
	    }
	}
    }
}
