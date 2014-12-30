# Sam Hage
# hand.rb
# LiveRamp interview
# 12/14

# Hand keeps track of hand objects and 
# the bets associated with each one

class Hand

	attr_accessor :cards
	attr_accessor :bet

	# @cards: an array of one or more cards
	# @bet: the bet associated with the hand (important for splitting)
	def initialize(card1, card2, bet)

		@cards = []
		@cards << card1 unless card1.nil?
		@cards << card2 unless card2.nil?
		#@cards.compact # remove nil values
		@bet = bet
	end

	# add a card to a player's hand
	def self.add_card(hand, c)
		hand.cards << c
		return hand
	end

	# return hand value
	def self.hand_value(hand)

		v = 0
		# if the hand is over 21 and there are any aces, treat one or more as 1s until no longer over 21
		num_aces = 0
		hand.cards.each {
			|x|
			num_aces += 1 if x.value == "A"
			v += x.num
		}
		while v > 21 && num_aces > 0
			v -= 10
			num_aces -= 1
		end

		return v
	end

	# prints an ascii representation of the card
	def self.print_card(hand, dealer=false)

		line1 = ""
		line2 = ""
		line3 = ""
		line4 = ""
		line5 = ""

		hand.cards.each {
			|x|
			line1 += " _____\t" # first line is always the same
			case x.suit
			when "H"
				line2 += "|" + x.value + "_ _ |\t"
				line3 += "|( v )|\t"
				line4 += "| \\ / |\t"
			when "D"
				line2 += "|" + x.value + "    |\t"
				line3 += "| / \\ |\t"
				line4 += "| \\ / |\t"
			when "C"
				line2 += "|" + x.value + " _  |\t"
				line3 += "| ( ) |\t"
				line4 += "|(_'_)|\t"
			when "S"
				line2 += "|" + x.value + "    |\t"
				line3 += "| / \\ |\t"
				line4 += "|(_._)|\t"
			end
			line5 += "|____" + x.value + "|\t" # last line is always the same
		}

		if dealer # dealer's first card is turned over
			back2 = "| _ _ |"
			back3 = "|  _  |"
			back4 = "| _ _ |"
			back5 = "|_____|"
			rest2 = line2[7..-1]
			rest3 = line3[7..-1]
			rest4 = line4[7..-1]
			rest5 = line5[7..-1]
			line2 = back2 + rest2
			line3 = back3 + rest3
			line4 = back4 + rest4
			line5 = back5 + rest5
		end
		puts line1
		puts line2
		puts line3
		puts line4
		puts line5
	end

	# check for a blackjack
	def self.is_blackjack?(hand)

		return false if hand.cards.length != 2
		face = ["T", "J", "Q", "K"]
		card1 = hand.cards[0]
		card2 = hand.cards[1]
		return (face.include? card1.value) && (card2.value == "A") || 
			   (face.include? card2.value) && (card1.value == "A")
	end	
end