package main

import "core:time"
import "core:os"
import "core:fmt"
import "core:strconv"

main :: proc() {
    if len(os.args) != 2 {
	fmt.println("usage: ./pomodin <time in minutes>")
	return
    }
    
    time_goal_mins, ok := strconv.parse_uint(os.args[1], 10)
    if !ok  {
	fmt.println("usage: ./pomodin <time in minutes>")
	fmt.printfln("\tyou've set the timer to `%v`", os.args[1])
	fmt.printfln("\ttime can only be a non-negative integer")
	return
    }

    time_start := time.tick_now()
    time_goal := time.tick_add(time_start, time.Minute * time.Duration(time_goal_mins))

    for time.tick_diff(time.tick_now(), time_goal) >= time.Duration(0) {}

    fmt.printfln("congrats! you've focused for %d minutes", time_goal_mins)
    play_audio()
    
    return
}
