require 'rspec'
require 'timeout'
require 'pry'
require_relative 'main'

describe 'Game' do
  it "should end" do
    Timeout::timeout(1) { Game.new.play.should == "Player One wins!" }
  end
end