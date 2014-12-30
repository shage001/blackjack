# Sam Hage
# card.rb
# LiveRamp interview
# 12/14

# Card is used to store cards' values and display them in a readable
# way, as well as deal hands

load "hand.rb"

DECK = [*1..52] # these arrays will be used to simulate a deck
$used_cards = [] 

class Card
	
	attr_reader :num	
	attr_reader :value
	attr_reader :suit

	# @num: the actual numerical value of a card
	# @value: the letter or number representing the card
	# @suit: the card's suit
	def initialize(number)

		@num = number%13
		case @num
		when 1 then @value = "A" ; @num = 11 # aces default to 11
		when 10 then @value = "T"
		when 11 then @value = "J" ; @num = 10
		when 12 then @value = "Q" ; @num = 10
		when 0 then @value = "K" ; @num = 10
		else @value = num.to_s
		end

		s = number/13
		case s
		when 1
			number%13 == 0 ? @suit = "H" : @suit = "D" # make sure kings are correct suit (multiples of 13 will be 0)
		when 2 
			number%13 == 0 ? @suit = "D" : @suit = "C"
		when 3
			number%13 == 0 ? @suit = "C" : @suit = "S"
		else @suit = "H"
		end

	end

	# creates two new cards, removes them from the deck,
	# adds them to a hand, and returns the hand
	def self.deal(bet)

		num1 = (DECK - $used_cards).sample
		$used_cards << num1
		num2 = (DECK - $used_cards).sample
		$used_cards << num2

		card1 = Card.new(num1)
		card2 = Card.new(num2)
		hand = Hand.new(card1, card2, bet)
		return hand
	end

	# creates a single new card
	def self.new_card

		num = (DECK - $used_cards).sample
		$used_cards << num
		card = Card.new(num)
		return card
	end
end