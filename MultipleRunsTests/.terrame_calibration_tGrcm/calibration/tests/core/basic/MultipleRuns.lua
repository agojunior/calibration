local s = package.config:sub(1, 1)
-- Creating Models
local MyModel = Model{
	x = Choice{-100, -1, 0, 1, 2, 100},
	y = Choice{min = 1, max = 10, step = 1},
	finalTime = 1,
	init = function(self)
		self.timer = Timer{
			Event{action = function()
				self.value = 2 * self.x ^2 - 3 * self.x + 4 + self.y
			end}
	}
	end
}
local MyModel2 = Model{
	x = Choice{-100, -1, 0, 1, 2, 100},
	y2 = Mandatory("number"),
	finalTime = 1,
	init = function(self)
		self.timer = Timer{
			Event{action = function()
				self.value = 2 * self.x ^2 - 3 * self.x + 4 + self.y2
			end}
	}
end
}
local MyModel3 = Model{
	parameters3 = {
		x = Choice{-100, -1, 0, 1, 2, 100, 200},
		y = Choice{min = 1, max = 10, step = 1},
		z = Choice{-50, -3, 0, 1, 2, 50}
	},
	finalTime = 1,
	init = function(self)
		self.timer = Timer{
			Event{action = function()
				self.value = 2 * self.parameters3.x ^2 - 3 * self.parameters3.x + 4 + self.parameters3.y
			end}
	}
end
}
-- It's here just so all lines are executed:
local MyModel3Inv = Model{
	parameters3 = {
		x = Choice{-100, -1, 0, 1, 2, 100},
		y = Choice{min = 1, max = 10, step = 1},
		f = Choice{1, 2 ,3}
	},
	finalTime = 1,
	init = function(self)
		self.timer = Timer{
			Event{action = function()
				self.value = 2 * self.parameters3.f ^2 - 3 * self.parameters3.f + 4 + self.parameters3.y
			end}
	}
end
}
local MyModel4 = Model{
	x = Choice{-100, -1, 0, 1, 2, 100},
	y = Choice{min = 1, max = 10, step = 1},
	z = Choice{-50, -3, 0, 1, 2, 50},
	finalTime = 1,
	init = function(self)
		self.timer = Timer{
			Event{action = function()
				self.value = self.z * 2 * self.x ^2 - 3 * self.x + 4 + self.y
			end}
	}
	end
}

return{
output = function(unitTest)
	local m = MultipleRuns{
		folderName = tmpDir()..s.."saveCSVTests",
		model = MyModel,
		strategy = "factorial",
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y = Choice{min = 1, max = 10, step = 1},
			finalTime = 1
		 },
		additionalF = function(model)
			return "test"
		end,
		output = function(model)
			return model.value
		end
	}
	unitTest:assert(m:get(1).output == 20305)
end,
get = function (unitTest)
	local m = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel,
		strategy = "factorial",
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y = Choice{min = 1, max = 10, step = 1},
			finalTime = 1
		 },
		additionalF = function(model)
			return "test"
		end,
		output = function(model)
			return model.value
		end
	}
	unitTest:assertEquals(m:get(1).x, -100)
	unitTest:assertEquals(m:get(1).y, 1)
	unitTest:assertEquals(m:get(1).simulations, 'finalTime_1_x_-100_y_1_')
end,
saveCSV = function(unitTest)
	local m = MultipleRuns{
		folderName = tmpDir()..s.."saveCSVTests",
		model = MyModel,
		strategy = "factorial",
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y = Choice{min = 1, max = 10, step = 1},
			finalTime = 1
		 },
		additionalF = function(model)
			return "test"
		end,
		output = function(model)
			return model.value
		end
	}
	m:saveCSV("results", ";")
	local myTable = CSVread("results.csv", ";")
	unitTest:assert(myTable[1]["x"] == -100)
	unitTest:assert(myTable[1]["additionalF"] == "test")
	unitTest:assert(myTable[1]["output"] == 20305)
end,
MultipleRuns = function(unitTest)
	-- print("M")
	local m = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel,
		strategy = "factorial",
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y = Choice{min = 1, max = 10, step = 1},
			finalTime = 1
		 },
		additionalF = function(model)
			return "test"
		end,
		output = function(model)
			return model.value
		end
	}
	local mQuant = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel,
		strategy = "factorial",
		repeats = 2,
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y = Choice{min = 1, max = 10, step = 1},
			finalTime = 1
		 },
		additionalF = function(model)
			return "test"
		end,
		output = function(model)
			return model.value
		end
	}
	local mMan = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel2,
		strategy = "factorial",
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y2 = Choice{min = 1, max = 10, step = 1},
			finalTime = 1
		 },
		additionalF = function(model)
			return "test"
		end,
		output = function(model)
			return model.value
		end
	}
	local mTab = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel3,
		strategy = "factorial",
		parameters = {
			parameters3 = {
				x = Choice{-100, -1, 0, 1, 2, 100},
				y = Choice{min = 1, max = 10, step = 1},
				z = 1	
			 },
			finalTime = 1
		},
		additionalF = function(model)
			return (model.value)
		end,
		output = function(model)
			return model.value
		end
	}
	local mTab2 = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel3Inv,
		strategy = "factorial",
		parameters = {
			parameters3 = {
				x = Choice{-100, -1, 0, 1, 2, 100},
				y = Choice{min = 1, max = 10, step = 1},
				f = 1	
			 },
			finalTime = 1
		},
		additionalF = function(model)
			return (model.value)
		end
	}
	local mSingle = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel4,
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y = Choice{min = 1, max = 10, step = 1},
			z = 1,
			finalTime = 1
		 },
		additionalF = function(model)
			return "test"
		end,
		output = function(model)
			return model.value
		end
	}
	local m2 = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel,
		strategy = "selected",
		parameters = {
			scenario1 = {x = 2, y = 5},
			scenario2 = {x = 1, y = 3}
		 },
		output = function(model)
			return model.value
		end,
		additionalF = function(model)
			return "test"
		end
	}
	local m2Tab = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel3,
		parameters = {
			scenario1 = {parameters3 = {x = 2, y = 5, z = 1}},
			scenario2 = {parameters3 = {x = 1, y = 3, z = 1}}
		 },
		output = function(model)
			return model.value
		end
	}
	local m3 = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel,
		strategy = "repeated",
		parameters = {x = 2, y = 5},
		repeats = 3,
		output = function(model)
			return model.value
		end,
		additionalF = function(model)
			return "test"
		end
	}
	local m3Tab = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel3,
		parameters = {parameters3 = {x = 2, y = 5, z = 1}},
		repeats = 3,
		output = function(model)
			return model.value
		end
	}
	local m4 = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel,
		strategy = "sample",
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y = Choice{min = 1, max = 10, step = 1}
		 },
		quantity = 5,
		output = function(model)
			return model.value
		end,
		additionalF = function(model)
			return "test"
		end
	}
	local m4Single = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel4,
		strategy = "sample",
		parameters = {
			x = Choice{-100, -1, 0, 1, 2, 100},
			y = Choice{min = 1, max = 10, step = 1},
			z = 1,
			finalTime = 1
		 },
		quantity = 5,
		output = function(model)
			return model.value
		end
	}
	local m4Tab = MultipleRuns{
		folderName = tmpDir()..s.."MultipleRunsTests",
		model = MyModel3,
		strategy = "sample",
		parameters = {
			parameters3 = {
				x = Choice{-100, -1, 0, 1, 2, 100},
				y = Choice{min = 1, max = 10, step = 1},
				z = 1
			},
		},
		quantity = 5,
		repeats = 2,
		output = function(model)
			return model.value
		end
	}
	unitTest:assertEquals(m:get(1).x, -100)
	unitTest:assertEquals(m:get(1).y, 1)
	unitTest:assertEquals(m:get(1).simulations, 'finalTime_1_x_-100_y_1_')
	unitTest:assertEquals(mQuant:get(1).simulations, '1_execution_finalTime_1_x_-100_y_1_')
	unitTest:assertEquals(mQuant:get(61).simulations, '2_execution_finalTime_1_x_-100_y_1_')
	unitTest:assertEquals(mMan:get(1).x, -100)
	unitTest:assertEquals(mMan:get(1).y2, 1)
	unitTest:assertEquals(mMan:get(1).simulations, 'finalTime_1_x_-100_y2_1_')
	unitTest:assertEquals(mTab:get(1).parameters3.x, -100)
	unitTest:assertEquals(mTab:get(1).parameters3.y, 1)
	unitTest:assertEquals(mTab2:get(1).parameters3.x, -100)
	unitTest:assertEquals(mTab2:get(1).parameters3.y, 1)
	unitTest:assertEquals(mTab:get(1).simulations, 'finalTime_1_parameters3_x_-100_parameters3_y_1_parameters3_z_1_')
	unitTest:assertEquals(mSingle:get(1).x, -100)
	unitTest:assertEquals(mSingle:get(1).y, 1)
	unitTest:assertEquals(mSingle:get(1).simulations, 'finalTime_1_x_-100_y_1_z_1_')
	unitTest:assertEquals(m2:get(1).x, 2)
	unitTest:assertEquals(m2:get(1).y, 5)
	unitTest:assertEquals(m2:get(2).x, 1)
	unitTest:assertEquals(m2:get(2).y, 3)
	unitTest:assertEquals(m2:get(1).simulations, "scenario1")
	unitTest:assertEquals(m2Tab:get(1).parameters3.x, 2)
	unitTest:assertEquals(m2Tab:get(1).parameters3.y, 5)
	unitTest:assertEquals(m2Tab:get(2).parameters3.x, 1)
	unitTest:assertEquals(m2Tab:get(2).parameters3.y, 3)
	unitTest:assertEquals(m2Tab:get(1).simulations, "scenario1")
	unitTest:assert(m3:get(1).x == 2 and m3:get(2).x == 2 and m3:get(3).x == 2)
	unitTest:assert(m3:get(1).y == 5 and m3:get(2).y == 5 and m3:get(3).y == 5)
	unitTest:assert(m3Tab:get(1).parameters3.x == 2 and m3Tab:get(2).parameters3.x == 2 and m3Tab:get(3).parameters3.x == 2)
	unitTest:assert(m3Tab:get(1).parameters3.y == 5 and m3Tab:get(2).parameters3.y == 5 and m3Tab:get(3).parameters3.y == 5)
	unitTest:assertEquals(m3:get(1).simulations, "1")
	unitTest:assertEquals(m3Tab:get(1).simulations, "1")
	unitTest:assert(m4:get(5).simulations == "5")
	unitTest:assertEquals(m4:get(1).simulations, "1")
	unitTest:assert(m4Tab:get(5).simulations == "1_execution_5")
	unitTest:assertEquals(m4Tab:get(6).simulations, "2_execution_1")
	unitTest:assertEquals(m4Tab:get(1).simulations, "1_execution_1")
	unitTest:assert(m4Single:get(5).simulations == "5")
	unitTest:assertEquals(m4Single:get(1).simulations, "1")
	unitTest:assertEquals(m:get(1).additionalF, "test")
end
}