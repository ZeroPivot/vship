require_relative "gmath"
require_relative "mouse"
require_relative "projectile"
require_relative "visualize"

include Gmath
LEFT = 0x8  #strange player controls are strange
RIGHT = 0x4
UP = 0x2
DOWN = 0x1
SMALL_C = 0.0000000001 #approximately zero

class Controller
	def initialize(screen)
		@screen = screen
		@background = Rubygame::Surface.load("./lib/background.png")
		@player = Player.new
		@mouse = Player_Mouse.new(0,0)	
		
		@queue = Rubygame::EventQueue.new()
		@clock = Rubygame::Clock.new()
		@clock.target_framerate = 60
		@player.place(250,250)
		@projectile_grp = Rubygame::Sprites::Group.new()
		@projectile_grp.extend(Rubygame::Sprites::UpdateGroup)
		
		@m_vector = Ftor.new(0,0) # <= VECTOR OF THE MOUSE
		@visualize = Visualize.new
		
		
	end
	
	#def putsd
	
	def fps_update()
		@screen.title = "FPS: #{@clock.framerate()}"
	end
	
	def updateMousePos()
		ship_minus_mouse = @player.vector - @mouse.vector
		ship_minus_mouse.x += SMALL_C
		ship_minus_mouse.y += SMALL_C		
		mag_ship_and_mouse = ship_minus_mouse.magnitude()
		adjacent = Ftor.new(@player.vector.x,@player.vector.y)
		adjacent.x = 0
		adjacent.y += SMALL_C if adjacent.y == 0
		c_projection=Gmath.mag_set(adjacent, ship_minus_mouse) #faster
		#c_projection.magnitude = ship_minus_mouse
		#c_projection.x += SMALL_C
		#c_projection.y += SMALL_C
		#puts adjacent.y
		#puts c_projection.magnitude()
		theta = Math.acos( c_projection.magnitude() / mag_ship_and_mouse )
		if ship_minus_mouse.x > 0 and ship_minus_mouse.y < 0
			#puts "a!"
			theta -= Math::PI
			theta *= -1
		elsif ship_minus_mouse.x < 0 and ship_minus_mouse.y > 0
			#puts "b!"
			theta *= -1
			theta -= 2 * Math::PI	
						
		elsif ship_minus_mouse.x < 0 and ship_minus_mouse.y < 0
			#puts "c!"
			theta -= Math::PI
						
		end	
		@player.rotate(theta)
	end
	
	def getPUnitRotation() #copypasta ... for now :=> creates a unit vector in the direction of the ship
		ship_minus_mouse = @player.vector - @mouse.vector
		ship_minus_mouse.x += SMALL_C
		ship_minus_mouse.y += SMALL_C
		mag_ship_and_mouse = ship_minus_mouse.magnitude()
		adjacent = Ftor.new(@player.vector.x,@player.vector.y) # prevent adjacent from MODIFYING the player vector itself ...
		#adjacent = @player.vector <= this would be a reference to @player ...
		adjacent.x = 0
		adjacent.y += SMALL_C if adjacent.y == 0
		c_projection=Gmath.mag_set(adjacent, ship_minus_mouse) #faster
		#c_projection.magnitude = ship_minus_mouse
		#c_projection.x += SMALL_C
		#c_projection.y += SMALL_C
		#puts adjacent.y
		#puts c_projection.magnitude()
		theta = Math.acos( c_projection.magnitude() / mag_ship_and_mouse )
		if ship_minus_mouse.x > 0 and ship_minus_mouse.y < 0
			#puts "a!"
			theta -= Math::PI
			theta *= -1
		elsif ship_minus_mouse.x < 0 and ship_minus_mouse.y > 0
			#puts "b!"
			theta *= -1
			theta -= 2 * Math::PI	
						
		elsif ship_minus_mouse.x < 0 and ship_minus_mouse.y < 0
			#puts "c!"
			theta -= Math::PI
						
		end	
		return Ftor.new(-Math::sin(theta), -Math::cos(theta)) #returns a unit vector of the ship facing the mouse
		#return [Math::cos(theta), Math::sin(theta)] #returns a unit vector
	end
	
	def run
		loop do
			@queue.each do |event|
			 case event
				when Rubygame::MouseMotionEvent					
					@mouse.update(event.pos[0], event.pos[1])			
				when Rubygame::QuitEvent
					Rubygame.quit()
					exit
				when Rubygame::KeyDownEvent				
						@player.keydown = true
						case event.key
						when Rubygame::K_ESCAPE
							Rubygame.quit()
							exit
						when Rubygame::K_RETURN
							a = Projectile.new(getPUnitRotation(),@player.centerx, @player.centery)
							#puts a
							a.speed=1 #lol
							#print "opps"
							
							@projectile_grp << a
							@visualize.append(a)
							#print "opps1"
						when Rubygame::K_LEFT							
							@player.dirBits!(LEFT | @player.dirBits?)
						when Rubygame::K_RIGHT							
							@player.dirBits!(RIGHT | @player.dirBits?)
						when Rubygame::K_UP							
							@player.dirBits!(UP | @player.dirBits?)
						when Rubygame::K_DOWN
							@player.dirBits!(DOWN | @player.dirBits?)
						end			
				
				when Rubygame::KeyUpEvent
					@player.keydown = false
					@player.lastKey nil
					case event.key
					 when Rubygame::K_LEFT
						@player.dirBits!(LEFT ^ @player.dirBits?)				
					 when Rubygame::K_RIGHT
						@player.dirBits!(RIGHT ^ @player.dirBits?)					
					 when Rubygame::K_UP
						@player.dirBits!(UP ^ @player.dirBits?)					 
					 when Rubygame::K_DOWN
						@player.dirBits!(DOWN ^ @player.dirBits?)				
				end
			end
		end
			fps_update()
			@background.blit(@screen,[0,0])
			
			if @player.dirBits? > 0
				case @player.dirBits?
					when UP | LEFT
						@player.dirx -= 1
						@player.diry -= 1
					when UP | RIGHT
						@player.dirx += 1
						@player.diry -= 1
					when DOWN | LEFT
						@player.dirx -= 1
						@player.diry += 1
					when DOWN | RIGHT
						@player.dirx += 1
						@player.diry += 1
					when UP
						@player.diry -= 1
					when DOWN
						@player.diry += 1
					when LEFT
						@player.dirx -= 1
					when RIGHT
						@player.dirx += 1					
				end
				
			elsif (@player.dirx.abs > 0 || @player.diry.abs > 0)
				if @player.dirx < 0
					@player.dirx += 1
				elsif @player.dirx > 0
					@player.dirx -= 1
				end
				
				if @player.diry < 0
					@player.diry += 1
				elsif @player.diry > 0
					@player.diry -= 1
				end
			end
			
			
				if @player.centerx < 0
					@player.centerx = 640
				elsif @player.centerx > 640
					@player.centerx = 0
				end	
				if @player.centery > 480
					@player.centery = 0
				elsif @player.centery < 0
					@player.centery = 480
				end
			

			
			#puts @player.dirBits?
			#print "snap"
			
			updateMousePos()
			@player.draw(@screen)
			#@projectile_grp.call("remove", self)
			@projectile_grp.update()
			#@projectile_grp.undraw(@screen,@background)
			@projectile_grp.draw(@screen)
			#@projectile_grp.clear()
			@visualize.blit(@background,@player)
			@screen.update			
			@player.updatex(@clock.tick*0.001)
			@player.updatey(@clock.tick*0.001)
		end
	end
end