require "rubygems"
require "rubygame"
include Rubygame
require_relative "lib/controller.rb"
require_relative "lib/setup.rb"
require_relative "lib/player.rb"


TTF.setup #setup true-type font manipulation

setup = Setup.new()
setup.run()