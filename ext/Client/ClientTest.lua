class "ClientTest"

local variablesTable = require "__shared/Variables"
local variables = nil

function ClientTest:RegisterEvents()
	variables = variablesTable:GetVariables()

    Events:Subscribe('clientTestMixed', self, self.OnClientTestMixed)
	Events:Subscribe('clientTestValue', self, self.OnClientTestValue)
	Events:Subscribe('clientTestValueTable', self, self.OnClientTestValueTable)
end


function ClientTest:CheckSameValue(valueOne, valueTwo)
	if valueOne == nil then
		error('ClientTest: variables table value was nil. <<<<<<<<<<<<<<<<<<<<<<')
		return false
	end
	
	if valueTwo == nil then
		error('ClientTest: value sent through NetEvents was nil. <<<<<<<<<<<<<<<<<<<<<<')
		return false
	end
		
	if valueOne ~= valueTwo then
		error('ClientTest: values were not the same - value one: ' .. tostring(valueOne) .. ' - value two: ' .. tostring(valueTwo))
		return false
	end
	
	return true
end

function ClientTest:OnClientTestMixed(guid, 
													 vecTwo, 
													 vecThree, 
													 vecFour, 
													 linearTransform)
													 
	if ClientTest:CheckSameValue(variables["guids"][1], guid) and
        ClientTest:CheckSameValue(variables["vecTwos"][1], vecTwo) and
        ClientTest:CheckSameValue(variables["vecThrees"][1], vecThree) and	
        ClientTest:CheckSameValue(variables["vecFours"][1], vecFour) and
        ClientTest:CheckSameValue(variables["linearTransforms"][1], linearTransform) then
		print('ClientTest:OnServerTestValue() Server -> Client success for mixed test')
	else
		error('ClientTest:OnServerTestValue() Server -> Client failed for mixed test <<<<<<<<<<<<<<<<<<<<<<')
	end
end

function ClientTest:OnClientTestValue(value, index, tableName)
	local shouldBeValue = variables[tableName][index]
	
	if shouldBeValue == nil then
		error('Tried to access the value at index ' .. index .. ' from table ' .. tableName .. ', but it was nil. <<<<<<<<<<<<<<<<<<<<<<')
	end
	
	if ClientTest:CheckSameValue(shouldBeValue, value) then
		print('ClientTest:OnServerTestValue() Server -> Client success for ' .. tableName)
	else
		error('ClientTest:OnServerTestValue() Server -> Client failed for ' .. tableName .. '. Values that were tested: Value 1: ' .. tostring(shouldBeValue) .. ', Value 2: ' .. tostring(value) .. ' <<<<<<<<<<<<<<<<<<<<<<')
	end
end

function ClientTest:OnClientTestValueTable(tbl, tableName) -- doesnt work, client crashes before getting here
	print('ClientTest:OnServerTestValueTable() received table ' .. tableName)

	for i,v in ipairs(tbl) do
		ClientTest:OnClientTestValue(v, i, tableName)
	end
end

return ClientTest