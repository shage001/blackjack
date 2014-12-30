# Sam Hage
# driver.rb
# LiveRamp interview
# 12/14

# driver for the blackjack game, involving dealing, betting, etc.

load "card.rb"
load "player.rb"
load "table.rb"
load "hand.rb"

$lost_money = 0 # dealer accumulates money lost by players

puts "WELCOME TO BLACKJACK. GOOD LUCK."
puts "Blackjack pays 3:2. Dealer must hit 16, stand 17."
puts "Press (q) at any time to quit."
num_players = 0
while num_players > 6 || num_players < 1
	print "How many players at the table? (up to six) "
	num_players = gets.chomp
	if num_players.downcase == "q"
		puts "Thanks for playing!"
		abort # quit immediately
	end
	num_players = num_players.to_i
end

players = []
num_players.times {

	new_player = Player.new(nil, 1000)
	players << new_player
}

while players.length > 0 # loop to play multiple hands until all players are out of money

	$lost_money = 0 # recalculated every hand based on player money
	$used_cards = [] # reset the deck

	players.delete_if { |p| p.money == 0 } # players with no money are removed at beginning of round

	bet = 0
	puts "\nPlace your bets (\'leave\' to leave game):"
	i = 1 # to keep track of players
	players.each {

		|p|
		bet = 0
		p.hands = []
		while bet <= 0 || bet > p.money # must bet a positive amount less than total money
			print "Player " + i.to_s + " bet (max $" + p.money.to_s + "): "
			bet = gets.chomp

			if bet.downcase == "q"
				puts "Thanks for playing!"
				abort # quit immediately
			end

			if bet.downcase == "leave"
				bet = 1 # so loop will exit
				p.delete = true
				puts "Player " + i.to_s + " has left the game."
			else
				bet = bet.to_i
			end
		end

		if !p.delete
			p.subtract_money(bet) # subtract bet from player's cash until after hand
			new_hand = Card.deal(bet)
			p.hands << new_hand
			$lost_money += (1000 - p.money) # calculate dealer money
		end
		i += 1
	}

	players.delete_if { |p| p.delete } # delete any player who 'leaves'
	break if players.empty? # quit immediately if all players are out

	dealer_hand = Card.deal(nil) # dealer doesn't make a bet
	puts "\n"

	Table.display(players, dealer_hand)

	dealer_blackjack = Hand.is_blackjack?(dealer_hand)

	i = 1 # to keep track of players
	players.each {

		|p|
		break if dealer_blackjack # hand would be over immediately
		j = 1 # to keep track of hands
		p.hands.each {

			|current|
			double = false
			while Hand.hand_value(current) <= 21 && !(Hand.is_blackjack?(current)) && !double

				splittable = false # can only split two same-value cards
				doubleable = false # can only double on first move

				if p.hands.length > 1
					puts "Player " + i.to_s + " hand " + j.to_s + ":" # multiple hands
				else
					puts "Player " + i.to_s + ":" # single hand
				end
				options = "Hit 	Stand 	"
				if current.cards.length == 2 && current.cards[0].value == current.cards[1].value && p.money >= current.bet
					options += "Double	Split"
					splittable = true
				elsif (current.cards.length == 1 || current.cards.length == 2) && p.money >= current.bet
					options += "Double" 
					doubleable = true
				end
				puts options
				choice = gets.chomp.downcase
				if choice.downcase == "q"
					puts "Thanks for playing!"
					abort # quit immediately
				end

				case choice
				when "hit"
					new_card = Card.new_card
					current = Hand.add_card(current, new_card)
				when "stand" then break # should just move on to next player
				when "double"
					if doubleable || splittable # don't allow user to double if the option isn't there
						new_card = Card.new_card
						current = Hand.add_card(current, new_card)
						double = true # make sure not to allow more moves after doubling
						current.bet *= 2 # doubling down doubles the bet
						p.subtract_money(current.bet/2)
					end
				when "split"
					if splittable # don't allow user to split if the option isn't there
						second_hand = Hand.new(current.cards[1], nil, current.bet) # create new hand with second card
						current.cards.delete_at(1) # delete second card
						p.hands << second_hand
						p.subtract_money(current.bet) # double the bet
						new_card1 = Card.new_card # deal new cards to each hand
						current = Hand.add_card(current, new_card1)
						new_card2 = Card.new_card
						second_hand = Hand.add_card(second_hand, new_card2)
					end
				else 
					puts "Please enter a valid choice"
				end
				Table.display(players, dealer_hand)
			end
			j += 1
		}
		i += 1
	}

	Table.display(players, dealer_hand, true)

	while Hand.hand_value(dealer_hand) < 17 # hit until 17 or over

		sleep(2) # pause between dealer hits
		new_card = Card.new_card
		dealer_hand.cards << new_card
		Table.display(players, dealer_hand, true)
	end

	to_beat = Hand.hand_value(dealer_hand) # dealer total
	puts "\n\n"
	if to_beat > 21
		puts "Dealer busts." 
	elsif dealer_blackjack
		puts "Dealer has blackjack." 
	else
		puts "Dealer has " + to_beat.to_s
	end
	i = 1 # keep track of players
	players.each {

		|p|
		j = 1 # keep track of hands
		p.hands.each {

			|current|
			player_hand = Hand.hand_value(current)
			amount = current.bet
			outcome = ""

			if player_hand > 21 # player bust
				outcome = "Player " + i.to_s + " busts"
				outcome += " on hand " + j.to_s if p.hands.length > 1
				puts outcome
			elsif Hand.is_blackjack?(current) # blackjack pays 3:2 unless dealer also has blackjack
				if dealer_blackjack
					p.add_money(amount) # get bet back
					outcome = "Player " + i.to_s + " ties"
					outcome += " on hand " + j.to_s if p.hands.length > 1
					puts outcome
				else
					amount += (3*amount)/2
					p.add_money(amount)
					outcome = "Player " + i.to_s + " wins $" + (amount-current.bet).to_s
					outcome += " on hand " + j.to_s if p.hands.length > 1
					puts outcome
				end
			elsif player_hand == to_beat # player ties dealer
				p.add_money(amount) # get bet back
				outcome = "Player " + i.to_s + " ties"
				outcome += " on hand " + j.to_s if p.hands.length > 1
				puts outcome
			elsif to_beat > 21 # dealer busts
				amount *= 2
				p.add_money(amount)
				outcome = "Player " + i.to_s + " wins $" + (amount/2).to_s
				outcome += " on hand " + j.to_s if p.hands.length > 1
				puts outcome
			elsif player_hand > to_beat # win but not blackjack
				amount *= 2
				p.add_money(amount)
				outcome = "Player " + i.to_s + " wins $" + (amount/2).to_s
				outcome += " on hand " + j.to_s if p.hands.length > 1
				puts outcome
			else # player has less than dealer
				outcome = "Player " + i.to_s + " loses $" + amount.to_s
				outcome += " on hand " + j.to_s if p.hands.length > 1
				puts outcome
			end
			j += 1
		}
		i += 1
	}
end