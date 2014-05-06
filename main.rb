require 'json'

class Game
  def initialize
    cards = JSON.parse(File.open("cards.json").read)['cards']
    cards = cards.map{|card| Card.new(card) }
    deck_one, deck_two = Deck.new(cards), Deck.new(cards)
    @player_one = Player.new(:first, deck_one)
    @player_two = Player.new(:second, deck_two)
    @player_one.other_player = @player_two
    @player_two.other_player = @player_one
  end
  def play
    while @player_one.alive? && @player_two.alive?
      [@player_one, @player_two].each {|player| player.take_turn }
    end
  rescue PlayerDeadException
  ensure
    return @player_one.alive? ? "Player One wins!": "Player Two wins!"
  end
end

class Player
  def initialize(first_or_second, deck)
    @deck = deck
    @hand = []
    @in_play = []
    self.life = 30
  end
  attr_accessor :life
  attr_writer :other_player

  def alive?
    life > 0
  end

  def take_turn
    draw_card
    take_action while can_take_action?
  end

  private
  def draw_card
    @hand << @deck.draw
  end

  def can_take_action?
    @hand.any?
  end

  def take_action
    if @in_play.any? {|card| card.can_attack? }
      @in_play.find { |card| card.can_attack? }.attack(@other_player)
    else
      play(pick_best(@hand))
    end
  end

  def pick_best(hand)
    hand.sample
  end

  def play(card)
    @in_play << card
  end
end

class Deck
  def initialize(cards)
    @cards = []
    30.times { @cards << cards.sample }
  end

  def draw
    @cards.pop
  end
end

class Card
  def initialize(card_hash)
    @attack = card_hash["attack"]
  end

  def play
  end

  def attack(player)
    player.life -= @attack
    puts player.life
    unless player.alive?
      raise PlayerDeadException
    end
  end

  def can_attack?
    @attack != nil && @attack > 0
  end
end

class PlayerDeadException < StandardError
end