package main

import "core:time"
import rl "vendor:raylib"

/* in mins */
default_timer	    : u32 : 30
default_break_short : u32 : 5
default_break_long  : u32 : 15

state := State{ 
    false,                                      /* focus time status  */
    false,                                      /* break time status  */
    default_timer,                              /* default focus time */
    time.tick_now(),                           		
    time.Minute * time.Duration(default_timer),
    0,                                          /* break time counter */
}

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

		if !state.breaktime {
		    state.break_count += 1
		    state.breaktime = true

		    break_mins: u32
		    if state.break_count % 4 == 0 {
			break_mins = default_break_long
			state.break_count = 0
		    } else {
			break_mins = default_break_short
		    }
		    
		    state.remaining_time = time.Minute * time.Duration(break_mins)
		    state.breaktime_tick = time.tick_add(time.tick_now(), state.remaining_time)
		} else {   
		    state.remaining_time = time.Minute * time.Duration(state.focus_goal_mins)
		    state.breaktime = false
		}
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
