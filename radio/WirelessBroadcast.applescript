global arc_centre
global smooth_every
set arc_centre to {100, 100}
set smooth_every to 5

on sine_of(x) -- http://www.apple.com/applescript/guidebook/sbrt/pgs/sbrt.08.htm
	repeat until x >= 0 and x < 360
		if x >= 360 then
			set x to x - 360
		end if
		if x < 0 then
			set x to x + 360
		end if
	end repeat
	
	set x to x * (2 * pi) / 360 --convert from degrees to radians
	
	set answer to 0
	set numerator to x
	set denominator to 1
	set factor to -(x ^ 2)
	
	repeat with i from 3 to 40 by 2
		set answer to answer + numerator / denominator
		set numerator to numerator * factor
		set denominator to denominator * i * (i - 1)
	end repeat
	
	return answer
end sine_of

on cosine_of(x)
	return sine_of(x + 90)
end cosine_of

on point_from(origin, angle, arm_length)
	set x_dist to (my sine_of(angle)) * arm_length
	set y_dist to (my cosine_of(angle)) * arm_length
	return {(item 1 of origin) + x_dist, (item 2 of origin) + y_dist}
end point_from

tell front window of application "OmniGraffle Professional 5"
	
	display dialog "Enter the size of the arc angle. (Between 0 and 360.)" default answer "45"
	
	set end_angle to text returned of the result as real
	
	display dialog "Enter the smallest arc radius." default answer "50"
	
	set arc_minradius to text returned of the result as real
	
	display dialog "Enter the arc spacing." default answer "15"
	
	set arc_spacing to text returned of the result as real
	
	display dialog "Enter the number of arcs to draw." default answer "6"
	
	set arc_howmany to text returned of the result as integer
	
	set numArcsDrawn to 0
	set arc_radius to arc_minradius
	repeat until numArcsDrawn = arc_howmany
		set angle to 0
		
		set start_point to my point_from(arc_centre, 0, arc_radius)
		set end_point to my point_from(arc_centre, end_angle, arc_radius)
		
		set intermediate_points to {start_point}
		repeat until angle >= end_angle - smooth_every
			set angle to angle + smooth_every
			set intermediate_points to intermediate_points & {my point_from(arc_centre, angle, arc_radius)}
		end repeat
		
		tell canvas 1
			make new line at beginning of graphics with properties {point list:intermediate_points & {end_point}, draws shadow:false}
		end tell
		
		set numArcsDrawn to numArcsDrawn + 1
		set arc_radius to arc_radius + arc_spacing
	end repeat
	
end tell
