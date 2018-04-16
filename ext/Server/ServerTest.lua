class "ServerTest"

local variablesTable = require "__shared/Variables"
local variables = nil

function ServerTest:RegisterEvents()
	variables = variablesTable:GetVariables()

    Events:Subscribe('serverTestMixed', self, self.OnServerTestMixed)
	Events:Subscribe('serverTestValue', self, self.OnServerTestValue)
	Events:Subscribe('serverTestValueTable', self, self.OnServerTestValueTable)
end

function ServerTest:CheckSameValue(valueOne, valueTwo)
	if valueOne == nil then
		error('ServerTest: variables table value was nil. <<<<<<<<<<<<<<<<<<<<<<')
		return false
	end
	
	if valueTwo == nil then
		error('ServerTest: value sent through NetEvents was nil. <<<<<<<<<<<<<<<<<<<<<<')
		return false
	end
		
	if valueOne ~= valueTwo then
		error('ServerTest: values were not the same - value one: ' .. tostring(valueOne) .. ' - value two: ' .. tostring(valueTwo))
		return false
	end
	
	return true
end

function ServerTest:OnServerTestMixed(guid, 
                                      vecTwo, 
                                      vecThree, 
                                      vecFour, 
                                      linearTransform)
													 
	if ServerTest:CheckSameValue(variables["guids"][1], guid) and
        ServerTest:CheckSameValue(variables["vecTwos"][1], vecTwo) and
        ServerTest:CheckSameValue(variables["vecThrees"][1], vecThree) and	
        ServerTest:CheckSameValue(variables["vecFours"][1], vecFour) and
        ServerTest:CheckSameValue(variables["linearTransforms"][1], linearTransform) then
		print('ServerTest:OnServerTestValue() Server -> Server success for mixed test')
	else
		error('ServerTest:OnServerTestValue() Server -> Server failed for mixed test <<<<<<<<<<<<<<<<<<<<<<')
	end
end

function ServerTest:OnServerTestValue(value, index, tableName)
	local shouldBeValue = variables[tableName][index]
	
	if shouldBeValue == nil then
		error('Tried to access the value at index ' .. index .. ' from table ' .. tableName .. ', but it was nil. <<<<<<<<<<<<<<<<<<<<<<')
	end
	
	if ServerTest:CheckSameValue(shouldBeValue, value) then
		print('ServerTest:OnServerTestValue() Server -> Server success for ' .. tableName)
	else
		error('ServerTest:OnServerTestValue() Server -> Server failed for ' .. tableName .. '. Values that were tested: Value 1: ' .. tostring(shouldBeValue) .. ', Value 2: ' .. tostring(value) .. ' <<<<<<<<<<<<<<<<<<<<<<')
	end
end

function ServerTest:OnServerTestValueTable(tbl, tableName) -- doesnt work, Server crashes before getting here
	print('ServerTest:OnServerTestValueTable() received table ' .. tableName)

	for i,v in ipairs(tbl) do
		ServerTest:OnServerTestValue(v, i, tableName)
	end
end

return ServerTest