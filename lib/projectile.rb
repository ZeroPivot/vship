require 'rubygame/ftor'
ROUNDS = 20

class Projectile
	RATE_OF_CHANGE = 5 #rate of change (speed and @vector = velocity) dfgdf
	
	OFFSET = 10
	THOUSAND_MILLISECONDS = 1000 
	LIFETIME = 20 * THOUSAND_MILLISECONDS #lifetime of a bullet in seconds (multiplied by a second in milliseconds)
	include Sprites::Sprite
	attr_accessor :pos_vector, :velocity_vector
	def initialize(dir_ftor,loc_x, loc_y) # dir_ftor => unit vector in a direction (probably the ship's)
		@groups = []
		@depth = 0
		@alive = true
		@image = Rubygame::Surface.load('./lib/bullet.png')
		@orig_image = @image
		@rect = @image.make_rect
		@velocity_vector = dir_ftor #velocity vector of the direction, only a unit vector at first		
		@pos_vector = Ftor.new(loc_x, loc_y) #position vector of the projectilt!!!!!!22
		offset = @velocity_vector
		offset.magnitude = OFFSET
		@pos_vector = @pos_vector + offset		
		@rect.centerx,@rect.centery = @pos_vector.x,@pos_vector.y	
		
		@life_clock = Clock.new()
		#@lifetime = LIFE		
		#@image.centerx = loc_x
		#@image.centery = loc_y
		
	end	
	
	def alive?
	  @alive
  end
	
	def speed=(rate_of_change) # distance/sec?
		@velocity_vector.magnitude = rate_of_change #complete the definition of a velocity vector?
	end
	
	#def speed+(amount)
	#	@velocity_vector.magnitude= @velocity.vector.magnitude() + amount
	#end
	
	def speed?
		@velocity_vector.magnitude()
	end
	
	def update
		#p @pos_vector
		#p @velocity_vector
		puts @life_clock.tick()
		
		#### different functions
		#self.speed = -5+SMALL_C+((@life_clock.lifetime().to_f / 1000.0)**3.0)#self.speed? + RATE_OF_CHANGE
		#self.speed = 5+SMALL_C+(10*Math::sin(@life_clock.lifetime().to_f / 1000.0)**3.0)
		self.speed = 5+SMALL_C+5*Math::sin(5*@life_clock.lifetime().to_f / 1000.0)
		#self.speed = SMALL_C+Math::exp(@life_clock.lifetime().to_f / 1000.0)
		####
		@pos_vector = @pos_vector + @velocity_vector #I think		
		@rect.centerx = @pos_vector.x
		@rect.centery = @pos_vector.y
		puts "TIEM: #{@life_clock.lifetime()}"
		puts "SPEED: #{self.speed?}"
		
		###### bullets that appear at the other side of the window
		if @pos_vector.x < 0			
		@rect.centerx =	@pos_vector.x = 640			
		elsif @pos_vector.x > 640
		@rect.centerx =	@pos_vector.x = 0				
		end	
		if @pos_vector.y > 480		
		@rect.centery =	@pos_vector.y = 0
		elsif @pos_vector.y < 0	
		@rect.centery =	@pos_vector.y = 480			
		end	
		#####
		
		#self.kill 
		if @life_clock.lifetime() >= LIFETIME
		  @alive = false
		  self.kill
		end
		
		
	end
	
	#def remove(s)
	#	if @ready_for_death == true
	#		s.delete(self)
	#	end
	#end
	
	
end
		