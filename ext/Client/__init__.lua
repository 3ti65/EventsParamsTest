class 'EventsParamsTestClient'

local variablesTable = require "__shared/Variables"
local clientTestClass = require "ClientTest"
local variables = nil

function EventsParamsTestClient:__init()
	print("Initializing EventsParamsTestClient")
	variables = variablesTable:GetVariables()
	
    self:RegisterEvents()
    clientTestClass:RegisterEvents()
end

function EventsParamsTestClient:RegisterEvents()
	NetEvents:Subscribe('startClientToClientTest', self, self.OnStartClientToClientTest)
end

function EventsParamsTestClient:OnStartClientToClientTest()
	Events:DispatchLocal('clientTestMixed',
						variables["guids"][1], 
						variables["vecTwos"][1], 
						variables["vecThrees"][1], 
						variables["vecFours"][1], 
						variables["linearTransforms"][1])

    EventsParamsTestClient:SendClientToClientEventTestValue('guids', 'Guid', 'clientTestValue')
    EventsParamsTestClient:SendClientToClientEventTestValue('vecTwos', 'Vec2', 'clientTestValue')
    EventsParamsTestClient:SendClientToClientEventTestValue('vecThrees', 'Vec3', 'clientTestValue')
    EventsParamsTestClient:SendClientToClientEventTestValue('vecFours', 'Vec4', 'clientTestValue')
    EventsParamsTestClient:SendClientToClientEventTestValue('linearTransforms', 'LinearTransform', 'clientTestValue')
	
	-- EventsParamsTestClient:SendClientEventTestTable('guids', 'Guid', 'clientTestValueTable')
	-- EventsParamsTestClient:SendClientEventTestTable('vecTwos', 'Vec2', 'clientTestValueTable')
	-- EventsParamsTestClient:SendClientEventTestTable('vecThrees', 'Vec3', 'clientTestValueTable')
	-- EventsParamsTestClient:SendClientEventTestTable('vecFours', 'Vec4', 'clientTestValueTable')
	-- EventsParamsTestClient:SendClientEventTestTable('linearTransforms', 'LinearTransform', 'clientTestValueTable')
end

function EventsParamsTestClient:SendClientToClientEventTestValue(tableName, valueName, eventName)
	for i,v in ipairs(variables[tableName]) do
		print('EventsParamsTestClient: Sending ' .. valueName .. ': ' .. tostring(v))
		Events:DispatchLocal(eventName, v, i, tableName)
	end
end

function EventsParamsTestClient:SendClientEventTestTable(tableName, valueName, eventName)
	print('EventsParamsTestClient: Sending all values of type ' .. valueName .. ' of table ' .. tableName .. ' at the same time')
	Events:DispatchLocal(eventName, variables[tableName], tableName)
end

g_EventsParamsTestClient = EventsParamsTestClient()
