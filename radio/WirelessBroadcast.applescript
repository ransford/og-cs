global arc_centre
global smooth_every
set arc_centre to {100, 100}
set smooth_every to 5

-- Uses the Taylor Expansion of sine to compute sin(x)
on sine_of(x)
	repeat until x is greater than or equal to 0 and x is less than 360
		if x is greater than or equal to 360 then
			set x to x - 360
		end if
		if x is less than 0 then
			set x to x + 360
		end if
	end repeat
	
	set x to x * (2 * pi) / 360
	
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

-- Computes cos(x)
on cosine_of(x)
	return sine_of(x + 90)
end cosine_of

-- Computes the endpoint coordinates of a ray starting at ORIGIN and projecting at angle ANGLE with length ARM_LENGTH --
on point_from(origin, angle, arm_length)
	set x_dist to (my cosine_of(angle)) * arm_length
	set y_dist to (my sine_of(angle)) * arm_length
	return {(item 1 of origin) + x_dist, (item 2 of origin) + y_dist}
end point_from

-- The main routine --
tell front window of application "OmniGraffle"
	-- Compute the total arc angle, and set up begin_angle and end_angle --
	display dialog "Enter the size of the arc angle in degrees." default answer "45"
	set angle to text returned of the result as real
	set end_angle to angle / 2
	set begin_angle to -end_angle
	
	-- Get the radius of the smallest arc --
	display dialog "Enter the smallest arc radius." default answer "50"
	set arc_minradius to text returned of the result as real
	
	-- Get the spacing between arcs, including input validation --
	display dialog "Enter the arc spacing." default answer "15"
	set arc_spacing to text returned of the result as real
	repeat until arc_spacing is greater than 0
		display dialog "Enter the arc spacing (> 0)." default answer "15"
		set arc_spacing to text returned of the result as real
	end repeat
	
	-- Get the number of arcs, including input validation --
	display dialog "Enter the number of arcs to draw." default answer "6"
	set arc_howmany to text returned of the result as integer
	repeat until arc_howmany is greater than 0
		display dialog "Enter the number of arcs to draw (> 0)." default answer "6"
		set arc_howmany to text returned of the result as integer
	end repeat
	
	-- Main loop, draws the arcs --
	set numArcsDrawn to 0
	set arc_radius to arc_minradius
	repeat until numArcsDrawn is greater than or equal to arc_howmany
		-- Compute start and ending segments. Do this outside the loop in case the angle is really small, smaller than smooth_every --
		set start_point to my point_from(arc_centre, begin_angle, arc_radius)
		set end_point to my point_from(arc_centre, end_angle, arc_radius)
		
		-- Compute the points that will be in the arc --
		---- Start point
		set arc_points to {start_point}
		
		---- Loop over points between start and end
		repeat with angle from begin_angle to (end_angle - smooth_every) by smooth_every
			set end of arc_points to my point_from(arc_centre, angle, arc_radius)
		end repeat
		
		---- End point
		set end of arc_points to end_point
		
		-- Add this arc to the canvas as a new line --
		tell canvas 1
			make new line at beginning of graphics with properties {line type:curved, point list:arc_points, draws shadow:false}
		end tell
		
		-- Update loop counters --
		set numArcsDrawn to numArcsDrawn + 1
		set arc_radius to arc_radius + arc_spacing
	end repeat
	
	-- Group all the arcs together, and select the group --
	set arc_group to assemble (graphics 1 thru arc_howmany)
	set connect to group only of arc_group to true
	set magnets of arc_group to {{1, 0}, {-1, 0}}
	set selection to {arc_group}
end tell
