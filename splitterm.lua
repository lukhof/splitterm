VERSION =  "0.0.1"

local micro = import("micro")
local config = import("micro/config")
local buffer = import("micro/buffer")
local util = import("micro/util")

local function splitterm_run(bp, args)

	--defensive programming
	if(#args <= 0) then
		micro.InfoBar():Error("please provide an interpreter")
		return
	end
	
	--get current cursor
	local currentCursor =  bp.Cursor

	--arguments for terminal
	local jobArgs = {}

	--create buffer
	local tmpBuffer = buffer.NewBuffer("", "/tmp/micro_splitterm")

	--open split
	local tmpBufferpane = bp:HSplitBuf(tmpBuffer) 

	if(currentCursor:HasSelection() == false) then

		--if no selection was made run whole file
		jobArgs = {args[1], bp.Buf.Path}
	else

		--if a selection was made run only selection
		local selection = currentCursor:GetSelection()

		--copy selection into new buffer		
		tmpBuffer:Insert({X = 1, Y = 1}, util.String(selection))
		tmpBuffer:Save()

		--create terminal arguments
		jobArgs = {args[1], tmpBuffer.Path}
	end

	--open terminal
	tmpBufferpane:TermCmd(jobArgs)
end


function init()
	config.MakeCommand("splitterm_run", splitterm_run, config.NoComplete)	
end
