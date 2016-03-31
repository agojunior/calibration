-- @example Infection example using SaMDE, simulates an infection spreading inside a school.
import("calibration")
random = Random{seed = 1232}
local infection = Model{
	contacts = Mandatory("number"),
	contagion = Choice{min = 0, max = 1},
	infected = 3,
	susceptible = 763,
	recovered = 0, 
	days = Mandatory("number"),
	finalTime = 13,
	counter = 1,
	chart = true,
	finalInfected = {},
	finalSusceptible = {},
	finalRecovered = {},
	init = function(self)
		self.total = self.infected + self.susceptible + self.recovered
		self.alpha = self.contagion * ( self.contacts / self.total)
		self.beta = 1 / self.days
		self.finalInfected[self.counter] = self.infected
		self.finalSusceptible[self.counter] = self.susceptible
		self.finalRecovered[self.counter] = self.recovered
		local graph
		if self.chart == true then
			graph = {inf = self.infected}
			Chart{
				target = graph,
		    	select = {"inf"}
			}
			graph:notify(0)
		end
	
		self.timer = Timer{
			Event{action = function()
				local susceptible =math.max(0, math.floor(0.5 + self.susceptible - (self.alpha * self.infected * self.susceptible))) 
				local infected = math.max(0, math.floor(0.5 + self.infected + (self.alpha * self.infected * self.susceptible) - (self.beta * self.infected)))
				local recovered = math.floor(0.5 + self.recovered + (self.beta * self.infected))
				self.susceptible = susceptible
				self.infected = infected
				self.recovered = recovered
				self.counter = self.counter + 1
				self.finalInfected[self.counter] = self.infected
				self.finalSusceptible[self.counter] = self.susceptible
				self.finalRecovered[self.counter] = self.recovered
				if self.chart then
					graph.inf = self.infected
					graph:notify(self.counter)
				end
			end}
	}
	end
}

local fluData = {3, 7, 25, 72, 222, 282, 256, 233, 189, 123, 70, 25, 11, 4}
local fluSimulation = SAMDE{
	model = infection,
	maxGen = 9, 
	parameters = {
		chart = false,
		contacts = Choice{min = 3, max = 50, step = 1},
		contagion = Choice{min = 0, max = 1},
		days = Choice{min = 1, max = 20, step = 1}
	},
	fit = function(model)
		local dif = 0
		forEachOrderedElement(model.finalInfected, function(idx, att, typ)
			dif = dif + math.abs(att - fluData[idx])
		end)
		return dif
end}
print("The smallest difference between fluData and the calibrated infection model is: ")
print(fluSimulation.fit)
print("best: ")
local modelF = fluSimulation.instance
		forEachOrderedElement(modelF.finalInfected, function(idx, att, typ)
			print("finalInfected["..idx.."] = "..att)
		end)
		forEachOrderedElement(modelF.finalSusceptible, function(idx, att, typ)
			print("finalSusceptible["..idx.."] = "..att)
		end)
		forEachOrderedElement(modelF.finalRecovered, function(idx, att, typ)
			print("finalRecovered["..idx.."] = "..att)
		end)
		print("days: "..modelF.days)
		print("contagion: "..modelF.contagion)
		print("contacts: "..modelF.contacts)
		print("total: "..modelF.total)
		print("alpha: "..modelF.alpha)
		print("beta: "..modelF.beta)
