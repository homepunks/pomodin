package main

import "core:fmt"
import "core:strings"
import "core:time"

progress_bar :: proc(time_goal: uint) {
    bar_width := 30
    total: i64 = 100
    minute: i64 = 60 * 1000

    for i in 0..=total {
	ratio := f64(i) / f64(total)
	filled := int(ratio * f64(bar_width))

	bar_contents := [2]string{strings.repeat("#", filled), strings.repeat(" ", bar_width - filled)}
	bar := strings.concatenate(bar_contents[:])
	fmt.printf("\r[%s] %.0f%%", bar, ratio * 100)
	
	time.sleep(time.Duration(i64(time.Millisecond) * minute * i64(time_goal) / total))
    }

    fmt.println()
}
