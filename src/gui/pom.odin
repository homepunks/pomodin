package main

import "core:time"
import rl "vendor:raylib"

default_timer : u32 : 1 /* in mins */
state := State{ false, default_timer, time.Minute * time.Duration(default_timer) }

main :: proc() {
    window := Window{ "POMODIN", 800, 600, 60 }
    rl.InitWindow(window.width, window.height, window.name)
    rl.SetTargetFPS(window.fps)
    defer rl.CloseWindow()

    time_goal := time.tick_add(time.tick_now(), state.remaining_time)    
    
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
	
	if press_button(window.width, window.height) || rl.IsKeyPressed(.SPACE) {
	    if state.countdown == false {
		time_goal = time.tick_add(time.tick_now(), state.remaining_time)
		state.countdown = true
	    } else {
		state.countdown = false
		state.remaining_time = time.tick_diff(time.tick_now(), time_goal)
	    }
	}
    }
}
