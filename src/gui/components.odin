package main

import "core:time"
import "core:fmt"
import rl "vendor:raylib"

GRUVBOX_GREY   :: rl.Color{0x28, 0x28, 0x28, 0xFF}
GRUVBOX_AQUA   :: rl.Color{0x68, 0x9D, 0x6A, 0xFF}
GRUVBOX_GREEN  :: rl.Color{0x98, 0x97, 0x1A, 0xFF}
GRUVBOX_YELLOW :: rl.Color{0xD7, 0x99, 0x21, 0xFF}
GRUVBOX_RED    :: rl.Color{0xCC, 0x24, 0x1d, 0xFF}
GRUVBOX_BLUE   :: rl.Color{0x45, 0x85, 0x88, 0xFF}

TIME_FONT_SZ : i32 : 120

Window :: struct {
    name:          cstring,
    width:         i32,
    height:        i32,
    fps:           i32,
}

State :: struct {
    countdown: bool,
    focus_goal_mins: u32,
}

draw_timer :: proc(window_width: i32, window_height: i32, time_goal: time.Tick) {
    rect_width: f32 = 540
    rect_height: f32 = 160
    
    rect := rl.Rectangle {
	x = (f32(window_width) - rect_width)/2,
        y = f32(window_height)/6,
        width = rect_width,
	height = rect_height,
    }
    
    rl.DrawRectangleRec(rect, GRUVBOX_GREEN)

    time, time_sz := draw_time(time_goal)
    rl.DrawText(time,
		i32(rect.x + rect.width / 2) - time_sz / 2,
		i32(rect.y + rect.height / 2) - TIME_FONT_SZ / 2,
		TIME_FONT_SZ, GRUVBOX_YELLOW)
}

draw_time :: proc(time_goal: time.Tick) -> (cstring, i32) {
    if state.countdown {
	remaining := time.tick_diff(time.tick_now(), time_goal)
	if remaining >= time.Duration(0) {
	    total_secs := int(time.duration_seconds(remaining))
	    mins := total_secs / 60
	    secs := total_secs % 60

	    time_str := fmt.ctprintf("%02d:%02d", mins, secs)
	    return time_str, rl.MeasureText(time_str, TIME_FONT_SZ) 
	}
    }
    
    fallback_time := fmt.ctprintf("%02d:00", default_timer)
    return fallback_time, rl.MeasureText(fallback_time, TIME_FONT_SZ)
}

press_button :: proc(window_width: i32, window_height: i32) -> bool {
    rect_width: f32 = 270
    rect_height: f32 = 120

    rect := rl.Rectangle {
	x = (f32(window_width) - rect_width)/2,
        y = f32(window_height) * 0.7,
        width = rect_width,
	height = rect_height,
    }

    txt    := fmt.ctprint("FOCUS!")
    txt_sz := rl.MeasureText(txt, TIME_FONT_SZ/2)
    
    defer rl.DrawText(txt,
		      i32(rect.x + rect.width / 2) - txt_sz / 2,
		      i32(rect.y + rect.height / 2) - TIME_FONT_SZ / 2 / 2,
		      TIME_FONT_SZ / 2, GRUVBOX_YELLOW)
    defer rl.DrawRectangleRec(rect, GRUVBOX_BLUE)
    
    return rl.GuiButton(rect, txt)
}
