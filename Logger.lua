
local Logger = {}

Logger.MaxLogs = 300
Logger.Enabled = true

local Buffer = {}
local Head = 1
local Count = 0
local Version = 0

local function Serialize(value, depth, budget)
    depth = depth or 0
    budget = budget or {Remaining = 40}

    budget.Remaining = budget.Remaining - 1

    if budget.Remaining < 0 then
        return "..."
    end

    if depth >= 3 then
        return "..."
    end

    if typeof(value) == "table" then
        local result = {}
        local added = 0

        for key, item in pairs(value) do
            added = added + 1

            if added > 20 then
                result["..."] = "More items omitted"
                break
            end

            result[tostring(key)] =
                Serialize(item, depth + 1, budget)
        end

        return result
    end

    if typeof(value) == "Instance" then
        return value:GetFullName()
    end

    local result = tostring(value)

    if #result > 300 then
        result = string.sub(result, 1, 300) .. "..."
    end

    return result
end

local function StoreEntry(name, path, method, args, category)
    local entry = {
        Name = name,
        Path = path,
        Method = method,
        Category = category,
        Arguments = Serialize(args or {}),
        Timestamp = os.date("%H:%M:%S")
    }

    local index

    if Count < Logger.MaxLogs then
        index = ((Head + Count - 1) % Logger.MaxLogs) + 1
        Count = Count + 1
    else
        index = Head
        Head = (Head % Logger.MaxLogs) + 1
    end

    Buffer[index] = entry
    Version = Version + 1

    return entry
end

-- Records an explicitly supplied game object.
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

    return StoreEntry(
        remote.Name,
        remote:GetFullName(),
        method,
        args,
        category
    )
end

-- Records an action performed by ShortName Hub itself.
function Logger:RecordAction(actionName, details)
    if not self.Enabled then
        return
    end

    return StoreEntry(
        tostring(actionName),
        "ShortName Hub/Actions",
        "Action",
        details or {},
        "Other"
    )
end

function Logger:GetLogs(category, search)
    local results = {}

    category = category or "All"
    search = string.lower(search or "")

    for i = Count, 1, -1 do
        local index = ((Head + i - 2) % self.MaxLogs) + 1
        local entry = Buffer[index]

        if entry then
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
    end

    return results
end

function Logger:GetStats()
    local stats = {
        Total = Count,
        FireServer = 0,
        InvokeServer = 0,
        Other = 0
    }

    for i = 1, Count do
        local index = ((Head + i - 2) % self.MaxLogs) + 1
        local entry = Buffer[index]

        if entry and stats[entry.Category] ~= nil then
            stats[entry.Category] =
                stats[entry.Category] + 1
        end
    end

    return stats
end

function Logger:GetVersion()
    return Version
end

function Logger:Export()
    local output = {}

    for i = Count, 1, -1 do
        local index = ((Head + i - 2) % self.MaxLogs) + 1
        local entry = Buffer[index]

        if entry then
            table.insert(output,
                "[" .. entry.Timestamp .. "] " ..
                entry.Method .. " | " ..
                entry.Path .. "\n" ..
                "Arguments: " ..
                game:GetService("HttpService"):JSONEncode(entry.Arguments)
            )
        end
    end

    return table.concat(output, "\n\n")
end

function Logger:Clear()
    table.clear(Buffer)
    Head = 1
    Count = 0
    Version = Version + 1
end

function Logger:SetEnabled(state)
    self.Enabled = state
end

return Logger
