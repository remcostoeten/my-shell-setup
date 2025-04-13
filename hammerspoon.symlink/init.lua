-- Create a function that simulates a left-click and calls your action
local function simulateClick()
	-- Simulate a left click
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, hs.mouse.getAbsolutePosition()):post()
	hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, hs.mouse.getAbsolutePosition()):post()

	-- Replace this with your desired action
	hs.alert.show("dwadwadwada b")
end

-- Set up a timer to repeatedly call simulateClick with a 100 ms interval
local clickTimer
local function startClicking()
	if not clickTimer then
		clickTimer = hs.timer.doAfter(0.1, function()
			simulateClick()
			clickTimer:start()
		end)
	end
end

-- Bind the action to a hotkey (e.g., F1 key)
hs.hotkey.bind({ "cmd", "alt" }, "F1", function()
	startClicking()
end)

-- Stop the clicking when you press F2
hs.hotkey.bind({ "cmd", "alt" }, "F2", function()
	if clickTimer then
		clickTimer:stop()
		clickTimer = nil
	end
	hs.alert.show("Clicking stopped")
end)
