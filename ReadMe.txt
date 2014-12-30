Sam Hage
ReadMe.txt
LiveRamp interview
12/14

Files needed to run program:
driver.rb
table.rb
player.rb
card.rb
hand.rb

The driver will run the program when executed from the command line, with a simple text interface using ascii representations for cards. Program supports up to six players at a time, starting with 1000 dollars each. Players may make any integer bet between 1 and their total balance. If a player reaches 0, he is automatically removed from the game. Individual players may also leave during the betting round for any hand. Players may double down on their first move, and may split if dealt two same-value cards. Split hands are treated as new hands and may be doubled or re-split. Players may not double or split if they have less than the original value of their bet remaining in their balance, as they must either double their bet or provide a second one, respectively. Dealer must stand on 17 and hit on 16. Blackjack pays 3:2. Dealer begins with a balance of 0 and accumulates (or loses) money based on how the players do.