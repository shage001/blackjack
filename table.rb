# Sam Hage
# table.rb
# LiveRamp interview
# 12/14

# Table is used to display the the table and all the
# players' hands, money, etc.

load "hand.rb"

module Table

	# display a single hand
	def self.display_cards(dollars, hand, dealer=false)

		puts "Cash: $" + dollars.to_s if dealer
		to_print = ""

		if dealer
			Hand.print_card(hand, true)
		else
			Hand.print_card(hand)
		end

		puts "Value: " + Hand.hand_value(hand).to_s unless dealer
		puts "BUST!" if Hand.hand_value(hand) > 21
		puts "BLACKJACK!" if Hand.is_blackjack?(hand)
		puts "\n"
	end

	# display everyone's cards and money
	def self.display(players, dealer_hand, over=false)

		puts "\n--------------------------------"
		i = 1
		players.each {

			|p|
			puts "Player " + i.to_s + ":"
			puts "Cash: $" + p.money.to_s
			p.hands.each {
				|current|
				Table.display_cards(nil, current)
			}
			i += 1
		}
		puts "Dealer: "
		if over
			Table.display_cards($lost_money, dealer_hand) # display dealer cards if round is over
		else
			Table.display_cards($lost_money, dealer_hand, true) # hide first card otherwise
		end
	end
end