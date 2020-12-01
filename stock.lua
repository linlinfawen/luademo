

local originalPrice = 20
local FirstHandquantity = 100
local percentage = 0.1
local ride = -1
local count = 2
local cost = originalPrice * FirstHandquantity
local stock = 1
local loss = 0

local dailyIncrease = 0.1
local earnCost = 0


print("原始股本 = ",cost)
--下跌过程
for i=1,count do
	loss = loss +  originalPrice*percentage*ride*stock*FirstHandquantity
	originalPrice = originalPrice + originalPrice*percentage*ride
	print("第",i,"股票亏损 = ",loss)
	cost = cost + originalPrice * FirstHandquantity
	stock = stock + 1
end

earnCost = math.abs(loss)
--上涨过程
local day = 1
ride = 1

while true do
	earnCost = earnCost - math.abs(originalPrice*dailyIncrease*ride*stock*FirstHandquantity)
	originalPrice = originalPrice + originalPrice*dailyIncrease*ride
	if earnCost <= 0 then
		--todo
		print("最后一次回本的数量 = ",earnCost)
		break
	end
	day = day + 1
end



print("股票价格 = ",originalPrice)
print("股本 = ",cost)
print("股票数量 = ",stock)
print("股票亏损 = ",loss)

print("涨多少天回本 = ", day)

