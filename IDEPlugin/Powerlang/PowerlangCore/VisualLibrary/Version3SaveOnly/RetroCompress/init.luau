local Encoder = {}
Encoder.__index = Encoder

local Deflate = require(script.Deflate)

local char_table = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
	'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
	's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '!', '#', '$', '%',
	'&', "'", '(', ')', '*', '+', ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '@', '[', ']', '^', '_', '`',
	'{', '|', '}', '~', ' '
}

local byte_lookup = {}
for i = 0, 255 do
	byte_lookup[i] = 93
end

-- Create a lookup table to map character byte values to indices in char_table
for i, v in ipairs(char_table) do
	byte_lookup[string.byte(v)] = i - 1
end

-- Initialize encoder state
function Encoder:init()
	self.queue = 0
	self.nbits = 0
	self.val = -1
end

-- Encode input string into encoded format
local function encode(self, input)
	local output = {}

	for i = 1, #input do
		-- Initialize a queue of bits, nbits representing the size of the queue
		-- The maximum value of a char is 255 (0b11111111) (1 byte)

		-- This writes one byte to the end of the queue
		self.queue = self.queue + string.byte(input, i) * bit32.lshift(1, self.nbits)
		self.nbits = self.nbits + 8

		-- Do we have at least 14 bits in the queue?
		while self.nbits > 13 do
			-- Get the last 13 bits of the queue
			local masked = bit32.band(self.queue, 0b111111111111) 

			-- Is using 13 bits enough?
			if masked > 0b111001000 then --456
				self.queue = bit32.rshift(self.queue, 13)
				self.nbits = self.nbits - 13
			else
				-- Get the last 14 bits of the queue
				masked = bit32.band(self.queue, 0b0011111111111111)
				self.queue = bit32.rshift(self.queue, 14)
				self.nbits = self.nbits - 14
			end
			-- That
			table.insert(output, char_table[masked % 93 + 1])
			table.insert(output, char_table[math.floor(masked / 93) + 1])
		end
	end

	return table.concat(output)
end

Encoder.encode = encode

-- Finalize encoding process
function Encoder:encode_end()
	local output = {}

	local function process()
		table.insert(output, char_table[self.queue % 93 + 1])
		return self.nbits > 7
	end

	if self.nbits > 0 and (process() or self.queue > 92) then
		table.insert(output, char_table[math.floor(self.queue / 93) + 1])
	end

	self:init()
	return table.concat(output)
end

local function find_index(char_table, char)
	for i, v in ipairs(char_table) do
		if v == char then
			return i
		end
	end
	return nil
end

-- Decode input string based on the encoding logic
local function decode(self, input)
	local output = {}
	self.queue = 0
	self.nbits = 0

	-- Iterate through the encoded string two characters at a time
	for i = 1, #input, 2 do
		local char1 = input:sub(i, i)
		local char2 = input:sub(i + 1, i + 1)

		local value1 = find_index(char_table, char1) - 1
		local value2 = find_index(char_table, char2) - 1

		-- Combine the values of the two characters to form a 14-bit value
		local combined = value1 + value2 * 93
		self.queue = self.queue + combined * bit32.lshift(1, self.nbits)
		self.nbits = self.nbits + 14

		-- Extract bytes from the queue while there are at least 8 bits
		while self.nbits >= 8 do
			local byte = bit32.band(self.queue, 0xFF)
			table.insert(output, string.char(byte))
			self.queue = bit32.rshift(self.queue, 8)
			self.nbits = self.nbits - 8
		end
	end

	return table.concat(output)
end

-- Helper function to find index of a character in char_table


Encoder.decode = decode

-- Finalize decoding process
function Encoder:decode_end()
	local output = {}

	if self.val ~= -1 then
		table.insert(output, string.char(self.queue + bit32.lshift(self.val, self.nbits)))
	end

	self:init()
	return table.concat(output)
end

function testdecode(input)
	local ptr = 1
	local output = 0
	local nbits = 0
	while ptr < #input do
		local twochars = string.sub(input, ptr, ptr+1)
		--    how the two chars are encoded:
		--table.insert(output, char_table[masked % 93 + 1])
		--table.insert(output, char_table[math.floor(masked / 93) + 1])
		local char1 = string.sub(twochars, 1, 1)
		local char2 = string.sub(twochars, 2, 2)
		local char1pos = table.find(char_table, char1)
		local char2pos = table.find(char_table, char2) -- char2pos = math.floor(masked / 93) + 1
		local char1masked = char1pos - 1
		local char2masked = 93 * (char2pos - 1)
		--output into output
		output += char1masked * bit32.lshift(1, nbits)
		nbits += 8
		output += char2masked * bit32.lshift(1, nbits)
		nbits += 8
		ptr += 2
	end
	print(output)
end

-- Exported API
return {
	compress = function(input)
		local encoder = setmetatable({}, Encoder)
		encoder:init()
		local comprinput, _ = Deflate.Deflate.Compress(input)
		return encoder:encode(comprinput) .. encoder:encode_end()
	end,

	coolerdecode = testdecode
}