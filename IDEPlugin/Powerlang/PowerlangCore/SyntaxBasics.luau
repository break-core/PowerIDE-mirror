local syntax = {
	AllowedCharsInDirectives="ABCDEFGHIJKLMNOPQRSTUVWXYZ@-",
	AllowedCharsInVariables="ABCDEFGHIJKLMNOPQRSTUVWXYZ_-.1234567890", -- . is intentional, do not remove
	CommentCharacter="#", -- this is not used anywhere, but im keeping it just in case
	                      -- the actual comment character is "--" (no quotes)
	Indentation={string.char(10), " ", "	", "\n"}, --string.char(10) is newline
	Operators="+-/*^%.:=<>~#",
	StringOpeners="\"",
	LogicGates={"and", "or", "not"},
	OrderOfOperations = {
		{"#"},
		{"."},
		{"^"},
		{"*", "/", "%"},
		{"+", "-"},
		{".."},
		{"==", "~=", "<", ">", "<=", ">="},
		{"and", "or", "not"},
		{","}, --pseudo-operator, it sets IsTuple to true and grabs all tokens before it
		{"="},
	},
	FlagsAvailable = {"BypassVariableAntiFilter", "UseVSV3", "DoNotIncludeWatermark", "AllowNoSemicolons", "UseIPathForEvents", "MultilineCallsTest"}
}

return syntax
