require 'chingu'

class Game < Chingu::Window

	def initialize
		super
		self.input = {esc: :exit}
		Player.create
	end
end

class Weapon < Chingu::GameObject
	has_traits :velocity, :timer

	def setup
		self.velocity_y = -10
		after(1000) {self.destroy}
	end

end

class Laser < Weapon

	def setup
		super
		@image = Gosu::Image["laser.png"]
	end
end

class MassDriver < Weapon

	def setup 
		super
		@image = Gosu::Image["mass_driver.png"]
	end
end

class Player < Chingu::GameObject

	def setup
		@x = 400
		@y = 300
		@weapons = [Laser, MassDriver]
		@current_weapon = 0
		@image = Gosu::Image["ship.png"]
		self.input = {
			holding_left: :left,
			holding_right: :right,
			space: :fire
		}
	end

	def fire
		if @current_weapon == 0
			@current_weapon = 1
		else
			@current_weapon = 0
		end
		@weapons[@current_weapon].create(x: @x, y: @y)
	end

	def left 
		@x -= 5
	end

	def right
		@x += 5
	end
end
Game.new.show
