-- a = os.clock()
-- for i = 1,10000000 do
-- 	local x = math.sin(i)
-- end
-- b = os.clock()
-- print(b-a)

-- a = os.clock()
-- local sin = math.sin
-- for i = 1,10000000 do
-- 	local x = sin(i)
-- end
-- b = os.clock()
-- print(b-a)

-- a = os.clock()
-- local sin = math.sin
-- for i = 1,10000000 do
-- 	x = math.sin(i)
-- 	x = math.sin(i)
-- 	x = math.sin(i)
-- 	x = math.sin(i)
-- 	x = math.sin(i)
-- end
-- b = os.clock()
-- print(b-a)

-- a = os.clock()

-- b = 2
-- c = 3
-- for i=1,100000000 do
-- 	b = b + c
-- 	-- print(i)
-- end



-- b = os.clock()
-- print(b-a)

-- a = os.clock()
-- local s = ''
-- for i = 1,300000 do
--     s = s .. 'a'
-- end
-- b = os.clock()
-- print(b-a)
-- print(s)
-- print("----------------")

-- a = os.clock()
-- local s = ''
-- local t = {}
-- for i = 1,300000 do
--     t[#t + 1] = 'a'
-- end
-- s = table.concat( t, '')
-- b = os.clock()
-- print(s)
-- print(b-a)
-- a = os.clock()
-- local t = {}
-- for i = 1970, 2000 do
--     t[i] = os.time({year = i, month = 6, day = 14})
-- end
-- b = os.clock()
-- print(b-a)

local function showTime(func )
	a = os.clock()

	func()

	b = os.clock()
	print(b-a)
end

showTime(function()
	local t = {}
	for i = 1, 2000000 do
	    t[i] = os.time({year = i, month = 6, day = 14})
	end
end)

showTime(function ()
	-- body
	local t = {}
	local aux = {year = nil, month = 6, day = 14}
	for i=1,2000000 do
		aux.year = i
		t[i] = os.time(aux)
	end
end)

