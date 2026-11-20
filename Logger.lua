
local Logger = {}

Logger.Logs = {}
Logger.MaxLogs = 1000
Logger.Enabled = true

local function Serialize(value, depth)
    depth = depth or 0

    if depth > 5 then
        return "..."
    end

    if typeof(value) == "table" then
        local result = {}

        for key, item in pairs(value) do
            result[tostring(key)] = Serialize(item, depth + 1)
        end

        return result
    end

    if typeof(value) == "Instance" then
        return value:GetFullName()
    end

    return tostring(value)
end

function Logger:Record(remote, method, args)
    if not self.Enabled then
        return
    end

    local category = "Other"

    if method == "FireServer" then
        category = "FireServer"
    elseif method == "InvokeServer" then
        category = "InvokeServer"
    end

    local entry = {
        Name = remote.Name,
        Path = remote:GetFullName(),
        Method = method,
        Category = category,
        Arguments = Serialize(args or {}),
        Timestamp = os.date("%H:%M:%S")
    }

    table.insert(self.Logs, 1, entry)

    while #self.Logs > self.MaxLogs do
        table.remove(self.Logs)
    end

    return entry
end

function Logger:GetLogs(category, search)
    local results = {}

    category = category or "All"
    search = string.lower(search or "")

    for _, entry in ipairs(self.Logs) do
        local matchesCategory =
            category == "All" or entry.Category == category

        local matchesSearch =
            search == "" or
            string.find(string.lower(entry.Name), search, 1, true) or
            string.find(string.lower(entry.Path), search, 1, true)

        if matchesCategory and matchesSearch then
            table.insert(results, entry)
        end
    end

    return results
end

function Logger:GetStats()
    local stats = {
        Total = #self.Logs,
        FireServer = 0,
        InvokeServer = 0,
        Other = 0
    }

    for _, entry in ipairs(self.Logs) do
        if stats[entry.Category] ~= nil then
            stats[entry.Category] =
                stats[entry.Category] + 1
        end
    end

    return stats
end

function Logger:Export()
    local output = {}

    for _, entry in ipairs(self.Logs) do
        table.insert(output,
            "[" .. entry.Timestamp .. "] " ..
            entry.Method .. " | " ..
            entry.Path .. "\n" ..
            "Arguments: " ..
            game:GetService("HttpService"):JSONEncode(entry.Arguments)
        )
    end

    return table.concat(output, "\n\n")
end

function Logger:Clear()
    table.clear(self.Logs)
end

function Logger:SetEnabled(state)
    self.Enabled = state
end

return Logger
