-- @example Basic example for testing Calibration type, 
-- using a simple equation and variating it's x and y parameters.

require("calibration")


local MyModel = Model{
	x = choice{ min = -100, max = 100, step = 2},
	y = choice{ -1, 2 ,3},
	init = function(self)
		model.timer = Timer{
			Event{action = function()
				self.value = 2 * self.x ^ 2 - 3 * self.x + 4 + self.y
			end}
		}
	end
}


c = Calibration{
	model = MyModel,
	finalTime = 1,
	parameters = {x ={ min = -100, max = 100, step = 2}, y = { -1, 2 ,3}},
	fit = function(model)
		return model.value
	end
}


-- local c3 = Calibration{
--	model = MyModel,
--  SAMDE = true,
--	finalTime = 1,
--	parameters = {x ={ min = -100, max = 100}, y = { min = 1, max = 10}},
--	fit = function(model)
--		return model.value
--	end
-- }

result = c:execute()
)
-- result3 = c3:execute()

print("result1: "..result)
