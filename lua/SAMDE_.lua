-------------------------------------------------------------
----                 Algoritmo SaMDE                     ----
----        Implementado por: Rodolfo A. Lopes           ----
-------------------------------------------------------------
-- TO DO: implement fitness function in evaluate
-- TO DO:implement finalTime from Calibration function
-- TO DO: keep the parameters final value for best result?

GLOBAL_RANDOM_SEED = os.time();
NUMEST = 4;
PARAMETERS = 3;

local function evaluate(ind, dim, model, paramList, finalTime, fit)
	local solution = {}
	for i = 1, dim do
		solution[paramList[i]] = ind[i]
	end
	local m = model(solution) 
	m:execute(finalTime)
	local err = fit(m)
	return err;
end

local function initPop(popTam, varMatrix, dim)
	math.randomseed(GLOBAL_RANDOM_SEED);
	math.random();
	-- print("initializing population ...");
	local popInit = {};
	for i = 1, popTam do
		local ind = {};
		for j = 1, dim do
			local lim = varMatrix[j];
			local minVar = lim[1];
			local maxVar = lim[2];
			local value = minVar + (math.random() * (maxVar - minVar));
			table.insert(ind,value);
		end
		for j = (dim+1), (dim + NUMEST*PARAMETERS) do
			local value = math.random();
			table.insert(ind,value);
		end
		table.insert(popInit,ind);
	end
	return popInit;
end

local function g3Rand(i,popTam)
	local rands = {};
	local a,b,c;
	repeat
		a = math.random(1,popTam);
	until a ~= i
	repeat
		b = math.random(1,popTam);
	until ( (a ~= b) and (b ~= i))
	repeat
		c = math.random(1,popTam);
	until ( (a ~= c) and (b ~= c) and (c ~= i))
	table.insert(rands,a);
	table.insert(rands,b);
	table.insert(rands,c);
	return rands;
end

local function g4Rand(i,popTam)
	local rands = {};
	local a,b,c,d;
	repeat
		a = math.random(1,popTam);
	until a ~= i
	repeat
		b = math.random(1,popTam);
	until ( (a ~= b) and (b ~= i))
	repeat
		c = math.random(1,popTam);
	until ( (a ~= c) and (b ~= c) and (c ~= i))
	repeat
		d = math.random(1,popTam);
	until ( (a ~= d) and (b ~= d) and (c ~= d) and (d ~= i))
	table.insert(rands,a);
	table.insert(rands,b);
	table.insert(rands,c);
	table.insert(rands,d);
	return rands;
end

local function copy(tab)
	local result = {};
	for i = 1, #tab do
		table.insert(result,tab[i]);
	end
	return result;
end

local function copyParameters(tab,dim)
	local result = {};
	for i = dim+1, #tab do
		table.insert(result,tab[i]);
	end
	return result;
end

local function repareP(parameter)
	local p = parameter;
	if( p < 0) then
		p = - p;
	elseif ( p > 1) then
		p = 2*1 - p;
	end
	return p;
end

local function oobTrea(xi, varMatrix, k)
	local lim = varMatrix[k];
	local minVar = lim[1];
	local maxVar = lim[2];
	local x = xi;
	if(x < minVar) then
		if(math.random() < 0.5) then
			x = minVar;
		else
			x = 2*minVar - x;
		end
	end
	if(x > maxVar) then
		if(math.random() < 0.5) then
			x = maxVar;
		else
			x = 2*maxVar - x;
		end
	end
	return x;
end

local function distancia(x,y,varMatrix,i)
	local dist = normaliza(x,varMatrix,i) - normaliza(y,varMatrix,i);
	dist = math.abs(dist);
	return dist;
end

function normaliza(x,varMatrix,i)
	local intervalo = varMatrix[i];
	local total = intervalo[2] - intervalo[1];
	local value = x - intervalo[1];
	local newValue = ((value*100)/total)/100;
	return newValue;
end

local function maxVector(vector,dim)
	local valueMax = vector[1];
	for i = 2, dim do
		if(vector[i] > valueMax) then
			valueMax = vector[i];
		end
	end
	return valueMax;
end

local function maxDiversity(pop,dim,maxPopulation,varMatrix)
	local varMax = {};
	local varMin = {};
	local vector = pop[1];
	for i = 1, dim do
		table.insert(varMax, vector[i]);
		table.insert(varMin, vector[i]);
	end
	for i = 2, maxPopulation do
		local vector = pop[i];
		for j = 1, dim do
			if(vector[j] > varMax[j]) then
				varMax[j] = vector[j];
			end
			if(vector[j] < varMin[j]) then
				varMin[j] = vector[j];
			end
		end
	end
	local dist = {};
	for i = 1, dim do
		local value = distancia(varMax[i],varMin[i],varMatrix,i);
		table.insert(dist, value);
	end
	local valueMax = maxVector(dist,dim);
	return valueMax;
end

local function SAMDE_(varMatrix, dim, model, paramList, finalTime, fit)
	local pop = {};
	local costPop = {};
	local maxPopulation = (dim * 10);
	pop = initPop(maxPopulation, varMatrix, dim);
	local bestCost = evaluate(pop[1], dim, model, paramList, finalTime, fit);
	local bestInd = copy(pop[1]);
	table.insert(costPop, bestCost);
	for i = 2, maxPopulation do
		local fitness = evaluate(pop[i], dim, model, paramList, finalTime, fit);
		table.insert(costPop,fitness);
		if(fitness<bestCost) then
			bestCost = fitness;
			bestInd = copy(pop[i])
		end
	end
	local cont = 0;
	
	-- print("evolution population ...");
	while( (bestCost > 0.001) and (maxDiversity(pop,dim,maxPopulation,varMatrix) > 0.001) ) do
		local cont = cont + 1;
		local popAux = {};
		for j = 1, maxPopulation do
			local params = copyParameters(pop[j],dim);
			local F = 0.7 + (math.random()*0.3);
			local rands = g3Rand(j,maxPopulation);
			local solution1, solution2, solution3;
			solution1 = pop[rands[1]];
			solution2 = pop[rands[2]];
			solution3 = pop[rands[3]];
			
			for k = 1, NUMEST do
				params[k] = repareP(solution1[dim+k] + F*(solution2[dim+k] - solution3[dim+k]));
			end
			
			local sumV = 0.0;
			for k = 1, NUMEST do
				sumV = sumV + params[k];
			end
			
			local _rand = math.random();
			local p = 0;
			local winV = 0;
			
			for k = 1, NUMEST do
				p = p + (params[k]/sumV);
				if(_rand > p) then
					winV = winV + 1;
				end
			end
			
			local fPos = 1 + NUMEST + 2*winV;
			params[fPos] = repareP(solution1[dim+fPos] + F*(solution2[dim+fPos] - solution3[dim+fPos]));
			local crPos = fPos + 1;
			params[crPos] = repareP(solution1[dim+crPos] + F*(solution2[dim+crPos] - solution3[dim+crPos]));

			local rand4 = g4Rand(j,maxPopulation);
			local solution1, solution2, solution3, solution4;
			solution1 = pop[rand4[1]];
			solution2 = pop[rand4[2]];
			solution3 = pop[rand4[3]];
			solution4 = pop[rand4[4]];
			local indexInd = pop[j];
			local index = math.random(1,dim);
			local ui = {};
			
			for k = 1, dim do
				if( math.random() <= params[crPos] or k == index or winV == 3) then
					if( winV == 0) then -- rand\1
						table.insert(ui,oobTrea(solution1[k] + params[fPos]*(solution2[k] - solution3[k]),varMatrix,k));
					elseif (winV == 1) then -- best\1
						table.insert(ui,oobTrea(bestInd[k] + params[fPos]*(solution1[k] - solution2[k]),varMatrix,k));
					elseif (winV == 2) then -- rand\2
						table.insert(ui,oobTrea(solution1[k] + params[fPos]*(solution2[k] - solution3[k]) + params[fPos]*(solution3[k] - solution4[k]),varMatrix,k));
					elseif (winV == 3) then -- current-to-rand
						table.insert(ui,oobTrea(indexInd[k] + params[fPos]*(solution1[k] - indexInd[k]) + params[fPos]*(solution2[k] - solution3[k]),varMatrix,k));
					end
				else
					table.insert(ui,indexInd[k]);
				end
			end
			
			for k = 1, (NUMEST*PARAMETERS) do
				if( math.random() <= params[crPos] ) then
					table.insert(ui,params[k]);
				else
					table.insert(ui,indexInd[dim+k]);
				end
			end
			
			local score = evaluate(ui, dim, model, paramList, finalTime, fit);
			if(score < costPop[j]) then
				table.insert(popAux,copy(ui));
				costPop[j] = score;
				if(score < bestCost) then
					bestCost = score;
					bestInd = copy(ui);
				end
			else
				table.insert(popAux,pop[j]);
			end
		end
		
		-- print("best: " .. bestCost);
		for j = 1, maxPopulation do
			pop[j] = copy(popAux[j]);
		end
		
	end
	-- print("Generation: " .. cont);
	

	local bestVariablesChoice = {}
	for i=1,dim do
		bestVariablesChoice[paramList[i]] = bestInd[i]
	end
	local finalTable = {bestCost = bestCost, bestVariables = bestVariablesChoice}
	return finalTable
end

function calibration(varMatrix, dim, model, paramList, finalTime, fit)


	local resultSAMDE = SAMDE_(varMatrix, dim, model, paramList, finalTime, fit);
	return resultSAMDE
end

