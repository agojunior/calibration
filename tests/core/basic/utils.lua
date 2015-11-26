local MyModel = Model{
	x = Choice{-100, -1, 0, 1, 2, 100},
	y = Choice{ min = 1, max = 10, step = 1},
	finalTime = 1,
	init = function(self)
		self.timer = Timer{
			Event{action = function()
				self.value = 2 * self.x ^2 - 3 * self.x + 4 + self.y
			end}
	}
	end
}
return{
randomModel = function(unitTest)
	local rParam = {
				x = Choice{-100, -1, 0, 1, 2, 100},
				y = Choice{min = 1, max = 10, step = 1}
			}
	local rs = randomModel(MyModel, rParam)
	unitTest:assertEquals(type(rs.value), "number")
	local rParam = {
				x = Choice{-100, -1, 0, 1, 2, 100},
				y = 5
			}
	local rs = randomModel(MyModel, rParam)
	unitTest:assertEquals(type(rs.value), "number")
end,
clone = function(unitTest)
	local original = {x = 42}
	local copy = clone(original)
	unitTest:assertEquals(copy.x, 42)
end,
checkParameters = function(unitTest)
	-- The tests for the checkParameter function are the same as the alternative Multiple Runs tests that use it.
	unitTest:assert(true)
end
}
