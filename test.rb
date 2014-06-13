require 'rspec'
require 'timeout'
require 'pry'
require_relative 'main'

describe 'Game' do
  it "should end" do
    Timeout::timeout(1) { expect(Game.new.play).to eq("Player One wins!") }
  end
end
