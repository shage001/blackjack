# Sam Hage
# player.rb
# LiveRamp interview
# 12/14

# Player keeps track of a player's hand and money

class Player

	attr_accessor :hands
	attr_reader :money
	attr_accessor :delete

	# @hand: a player's hand (an array containing at least one Card object)
	# @money: a player's cash balance
	def initialize(hand, balance=1000)
		@hands = []
		@hands << hand unless hand == nil
		@money = balance
		@delete = false
	end

	# add money to a player's balance
	def add_money(amount)
		@money += amount
		return @money
	end

	# subtract money from a player's balance
	def subtract_money(amount)
		@money -= amount
		@money = 0 if @money < 0
		return @money
	end
end