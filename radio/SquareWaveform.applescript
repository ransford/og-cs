global wave_start
global smooth_every
set wave_start to {100.0, 100.0}

-- The main routine --
tell front window of application "OmniGraffle 5"
	-- Get the wavelength --
	display dialog "Enter the width." default answer "15"
	set wave_width to text returned of the result as real
	repeat until wave_width is greater than 2
		display dialog "Enter the width (> 2)." default answer "15"
		set wave_width to text returned of the result as real
	end repeat
	
	-- Get the wave height --
	display dialog "Enter the wave height." default answer "30"
	set wave_height to text returned of the result as real
	repeat until wave_height is greater than 2
		display dialog "Enter the wave height (> 2)." default answer "30"
		set wave_height to text returned of the result as real
	end repeat
	
	-- Get the number of wavelengths --
	display dialog "Enter the number of half-waves." default answer "6"
	set half_wave_count to text returned of the result as integer
	repeat until half_wave_count is greater than 0
		display dialog "Enter the number of half-waves (> 0)." default answer "6"
		set half_wave_count to text returned of the result as integer
	end repeat
	
	-- Main loop, draws the waves --
	set wave_start_x to item 1 in wave_start
	set wave_start_y to item 2 in wave_start
	set wave_points to {}
	repeat with wave from 0 to half_wave_count
		set wave_x to wave_start_x + wave * wave_width
		if wave mod 2 is 0 then
		 -- bottom of square wave
			set wave_y to wave_start_y
			set end of wave_points to {wave_x, wave_y}
			 -- top of square wave
			set wave_y to wave_start_y - wave_height
			set end of wave_points to {wave_x, wave_y}
		else
		 -- top of square wave
			set wave_y to wave_start_y - wave_height
			set end of wave_points to {wave_x, wave_y}
			 -- bottom of square wave
			set wave_y to wave_start_y
			set end of wave_points to {wave_x, wave_y}
		end if
	end repeat
	
	-- Add this wave to the canvas as a new line --
	tell canvas 1
		make new line at beginning of graphics with properties {line type:orthogonal, point list:wave_points, draws shadow:false}
	end tell
	
	set selection to {graphic 1}
end tell