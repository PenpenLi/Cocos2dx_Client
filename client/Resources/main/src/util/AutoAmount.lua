AutoAmount = class("AutoAmount")

function AutoAmount:ctor(default)
	self.amount_ = default or 0
end

function AutoAmount:increase()
	self.amount_ = self.amount_ + 1
	return self.amount_
end

function AutoAmount:decrease()
	self.amount_ = self.amount_ + 1
	return self.amount_
end