local Core = require(script.Parent.Parent.Core)
local SharedClasses = require(script.Parent.Parent.SharedClasses)

print(Core.Parse([[


]]), SharedClasses.ExecutableContext("<executed>", {}, false))
