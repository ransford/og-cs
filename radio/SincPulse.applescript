global wave_start
global smooth_every
set wave_start to {100.0, 100.0}
set smooth_every to 30 -- Dan: I tried all factors of 90 (degrees) from 5 to 45, thought 30 was the highest that looked good

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

-- The main routine --
tell front window of application "OmniGraffle"
	-- Get the wavelength --
	display dialog "Enter the wavelength." default answer "30"
	set wave_length to text returned of the result as real
	repeat until wave_length is greater than 5
		display dialog "Enter the wavelength (> 5)." default answer "30"
		set wave_length to text returned of the result as real
	end repeat
	
	-- Get the wave height --
	display dialog "Enter the wave height." default answer "60"
	set wave_height to text returned of the result as real
	repeat until wave_height is greater than 2
		display dialog "Enter the wave height (> 2)." default answer "60"
		set wave_height to text returned of the result as real
	end repeat
	
	-- Get the number of wavelengths --
	display dialog "Enter the number of waves on each side." default answer "3"
	set wave_count to text returned of the result as real
	repeat until wave_count is greater than 0
		display dialog "Enter the number of waves on each side (> 0)." default answer "3"
		set wave_count to text returned of the result as real
	end repeat
	
	-- Main loop, draws the waves --
	set wave_start_x to item 1 in wave_start
	set wave_start_y to item 2 in wave_start
	set wave_points to {{wave_start_x, wave_start_y - wave_height}}
	repeat with wave_angle from smooth_every to (360 * wave_count - smooth_every) by smooth_every
		set waves to wave_angle / 360.0
		set dx to waves * wave_length
		set dy to -(my sine_of(wave_angle)) * wave_height / (waves * 2 * pi)
		set beginning of wave_points to {wave_start_x - dx, wave_start_y + dy}
		set end of wave_points to {wave_start_x + dx, wave_start_y + dy}
	end repeat
	-- Last point --
	set dx to wave_count * wave_length
	set dy to -(my sine_of(360 * wave_count)) * wave_height / (wave_count * 2 * pi)
	set beginning of wave_points to {wave_start_x - dx, wave_start_y + dy}
	set end of wave_points to {wave_start_x + dx, wave_start_y + dy}
	
	-- Add this wave to the canvas as a new line --
	tell canvas 1
		make new line at beginning of graphics with properties {line type:curved, point list:wave_points, draws shadow:false}
	end tell
	
	set selection to {graphic 1}
end tell
