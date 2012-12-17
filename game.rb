require 'chingu'

class Game < Chingu::Window

	def initialize
		super
		self.input = {esc: :exit}
		4.times { Enemy.create }
		Player.create
	end

	def update
		super
		Laser.each_bounding_circle_collision(Enemy) do |weapon,enemy|
			weapon.destroy
			enemy.destroy
		end

		MassDriver.each_bounding_circle_collision(Player) do |weapon,player|
			weapon.destroy
			player.destroy
		end		
	end
end

class Weapon < Chingu::GameObject
	has_traits :velocity, :timer, :collision_detection, :bounding_circle

	def setup
		self.velocity_y = -10
		after(1500) {self.destroy}
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
		self.velocity_y = 5
	end

	def update
		super
		@angle += 8
	end

end

class Player < Chingu::GameObject

	has_traits :collision_detection, :bounding_circle

	def setup
		@x = 400
		@y = 500
		@current_weapon = 0
		@image = Gosu::Image["ship.png"]
		self.input = {
			holding_left: :left,
			holding_right: :right,
			space: :fire_laser}
	end

	def fire_laser
		Laser.create(x: @x, y: @y)
	end

	def left 
		@x -= 5 unless @x <= 20
	end

	def right
		@x += 5 unless @x >= 780
	end
end

class Enemy < Chingu::GameObject

	has_traits :collision_detection, :bounding_circle, :timer

	def setup
		@image = Gosu::Image["alien.png"]
		@x = rand(800)
		@y = rand(200) + 20
		@velocity_x = 3
	end

	def update
		super
		if @x >= 780 || @x <= 20
			@velocity_x *= -1
		end

		if rand(1000) > 975
			fire
		end

		@x += @velocity_x
	end

	def fire
		MassDriver.create(x: @x, y: @y)
	end

end

Game.new.show
