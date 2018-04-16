class 'EventsParamsTestServer'

local stringExtensions = require "__shared/StringExtensions"
local variablesTable = require "__shared/Variables"
local variables = nil
local serverTestClass = require "ServerTest"

function EventsParamsTestServer:__init()
	print("Initializing EventsParamsTestServer")
	variables = variablesTable:GetVariables()
	
    self:RegisterEvents()
    serverTestClass:RegisterEvents()
end

function EventsParamsTestServer:RegisterEvents()
	Events:Subscribe('Player:Chat', self, self.OnChat)
end

function EventsParamsTestServer:OnChat(player, recipientMask, message)
	if message == '' then
		return
	end

	print(message)
	
	local parts = message:split(' ')
	
	if parts[1] == 'serverserver' then
        EventsParamsTestServer:OnStartServerToServerTest()
	end
	
	if parts [1] == 'clientclient' then
		NetEvents:SendTo('startClientToClientTest', player)
	end
end

function EventsParamsTestServer:OnStartServerToServerTest()
	Events:DispatchLocal('serverTestMixed',
						variables["guids"][1], 
						variables["vecTwos"][1], 
						variables["vecThrees"][1], 
						variables["vecFours"][1], 
						variables["linearTransforms"][1])

    EventsParamsTestServer:SendServerToServerEventTestValue('guids', 'Guid', 'serverTestValue')
    EventsParamsTestServer:SendServerToServerEventTestValue('vecTwos', 'Vec2', 'serverTestValue')
    EventsParamsTestServer:SendServerToServerEventTestValue('vecThrees', 'Vec3', 'serverTestValue')
    EventsParamsTestServer:SendServerToServerEventTestValue('vecFours', 'Vec4', 'serverTestValue')
    EventsParamsTestServer:SendServerToServerEventTestValue('linearTransforms', 'LinearTransform', 'serverTestValue')
	
	-- EventsParamsTestServer:SendServerEventTestTable('guids', 'Guid', 'serverTestValueTable')
	-- EventsParamsTestServer:SendServerEventTestTable('vecTwos', 'Vec2', 'serverTestValueTable')
	-- EventsParamsTestServer:SendServerEventTestTable('vecThrees', 'Vec3', 'serverTestValueTable')
	-- EventsParamsTestServer:SendServerEventTestTable('vecFours', 'Vec4', 'serverTestValueTable')
	-- EventsParamsTestServer:SendServerEventTestTable('linearTransforms', 'LinearTransform', 'serverTestValueTable')
end

function EventsParamsTestServer:SendServerToServerEventTestValue(tableName, valueName, eventName)
	for i,v in ipairs(variables[tableName]) do
		print('EventsParamsTestServer: Sending ' .. valueName .. ': ' .. tostring(v))
		Events:Dispatch(eventName, v, i, tableName)
	end
end

function EventsParamsTestServer:SendServerEventTestTable(tableName, valueName, eventName)
	print('EventsParamsTestServer: Sending all values of type ' .. valueName .. ' of table ' .. tableName .. ' at the same time')
	Events:Dispatch(eventName, variables[tableName], tableName)
end

g_EventsParamsTestServer = EventsParamsTestServer()
