-- Make sure you set this convar: 
-- set es_enableCustomData 1

local loadedData = {}

AddEventHandler('es_db:firstRunCheck', function(ip, port)
	local lData = LoadResourceFile("esplugin_json", "data/users.json")
	loadedData = json.decode(lData or "{}")

	if not lData then
		SaveResourceFile("esplugin_json", "data/users.json", json.encode(loadedData), -1)
	end
end)

AddEventHandler('es_db:doesUserExist', function(identifier, callback)
	if loadedData[identifier] then
		callback(true)
	else
		callback(false)
	end
end)

AddEventHandler('es_db:retrieveUser', function(identifier, callback)
	if loadedData[identifier] then
		callback(loadedData[identifier])
	else
		callback(false)
	end
end)

AddEventHandler('es_db:createUser', function(identifier, license, cash, bank, callback)
	local user = { identifier = identifier, money = cash or 0, bank = bank or 0, license = license, group = "user", permission_level = 0 }

	loadedData[identifier] = user
	SaveResourceFile("esplugin_json", "data/users.json", json.encode(loadedData), -1)
	callback()
end)



AddEventHandler('es_db:retrieveLicensedUser', function(license, callback)
	if loadedData[identifier] then
		callback(loadedData[identifier])
	else
		callback(false)
	end
end)

AddEventHandler('es_db:doesLicensedUserExist', function(license, callback)
	if loadedData[identifier] then
		callback(true)
	else
		callback(false)
	end
end)

AddEventHandler('es_db:updateUser', function(identifier, new, callback)
	Citizen.CreateThread(function()
		for k,v in pairs(new)do
			loadedData[identifier][k] = v
		end

		SaveResourceFile("esplugin_json", "data/users.json", json.encode(loadedData), -1)
	end)
end)