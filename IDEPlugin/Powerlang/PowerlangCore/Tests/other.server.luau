local Core = require(script.Parent.Parent.Core)
local SharedClasses = require(script.Parent.Parent.SharedClasses)

Core.Parse([[-- Do not include watermark in source
@flag DoNotIncludeWatermark;

print(1 == 1);

]], SharedClasses.ExecutableContext("<executed>", {}, false))