local MyModelSamde = Model{
	x = Choice{min = 1, max = 10},
	y = Choice{min = 1, max = 10},
	finalTime = 1,
	init = function(self)
		self.timer = Timer{
			Event{action = function()
				self.value = 2 * self.x ^2 - 3 * self.x + 4 + self.y
			end}
		}
end}
local c2 = SAMDE{
	model = MyModelSamde,
	parameters = {x = {min = 1, max = 10}, y = { min = 1, max = 10}},
	fit = function(model)
		return model.value
end}
return{
SAMDE = function(unitTest)
unitTest:assertEquals(c2.fit, 4)
unitTest:assertEquals(c2.instance.x, 1)
unitTest:assertEquals(c2.instance.y, 1)
end}