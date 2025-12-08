package main

import "core:time"
import rl "vendor:raylib"

main :: proc() {
    state := State{ true, 30 }
    window := Window{ "POMODIN", 800, 600, 60 }
    rl.InitWindow(window.width, window.height, window.name)
    rl.SetTargetFPS(window.fps)
    defer rl.CloseWindow()

    time_goal := time.tick_add(time.tick_now(), time.Minute * time.Duration(state.focus_goal_mins))
    
    for !rl.WindowShouldClose() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	
	rl.ClearBackground(GRUVBOX_GREY)

	draw_timer(window.width, window.height, time_goal)

	if state.countdown {
	    if time.tick_diff(time.tick_now(), time_goal) <= time.Duration(0) {
		state.countdown = false
		play_audio()
	    }
	}

	if press_button(window.width, window.height) {
	    state.focus_goal_mins = 30
	    state.countdown = true
	    time_goal = time.tick_add(time.tick_now(), time.Minute * time.Duration(state.focus_goal_mins))
	}
    }
}
