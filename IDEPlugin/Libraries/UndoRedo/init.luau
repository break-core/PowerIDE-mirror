-- this whole library is ai generated cuz i couldnt be bothered to write it myself
--                 - vopwn55

local UndoRedo = {}

-- Constants
local MAX_STACK_SIZE = 500

-- Stacks for undo/redo
local undoStack = {}
local redoStack = {}

-- Add a new string to the undo stack and reset the redo stack
function UndoRedo.RecordString(str)
	-- Add to undo stack
	table.insert(undoStack, str)

	-- If undo stack exceeds the limit, remove the oldest
	if #undoStack > MAX_STACK_SIZE then
		table.remove(undoStack, 1)
	end

	-- Clear the redo stack when a new string is recorded
	redoStack = {}
end

-- Undo operation: move the latest string from undo stack to redo stack
function UndoRedo.Undo()
	if UndoRedo.CanUndo() then
		-- Get the latest string from the undo stack
		local str = table.remove(undoStack)

		-- Move it to the redo stack
		table.insert(redoStack, str)

		-- Return the string
		if #undoStack > 0 then
			return undoStack[#undoStack]
		end
		return "" -- If undoStack is empty after operation
	end
	return nil -- If nothing to undo
end

-- Redo operation: move the latest string from redo stack to undo stack
function UndoRedo.Redo()
	if UndoRedo.CanRedo() then
		-- Get the latest string from the redo stack
		local str = table.remove(redoStack)

		-- Move it back to the undo stack
		table.insert(undoStack, str)

		-- Return the string
		return str
	end
	return nil -- If nothing to redo
end

-- Check if undo is possible
function UndoRedo.CanUndo()
	return #undoStack > 0
end

-- Check if redo is possible
function UndoRedo.CanRedo()
	return #redoStack > 0
end

return UndoRedo
