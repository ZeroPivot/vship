#it will have to be integrated with projectile somehow?
require "rubygame/ftor"

class Visualize
  WIDTH = 640
  HEIGHT = 480
  include Rubygame
  def initialize(width=WIDTH,height=HEIGHT)
    @groups = []
    @bullets = []
    @depth = 0
    @width,@height = width,height
    @surface = Surface.new([width,height])
    @orig_surface = Surface.new([width,height])
    @original_background = Surface.load("./lib/background.png") #wouldn't figure out how to duplicate this stuff
    @original_surface = Surface.new([width,height])
    @ob_rect = @original_background.make_rect  
    @os_rect = @original_surface.make_rect
    
  end
  
  def blit(onto,ship)
    @original_background.blit(@surface,[0,0]) #reverse blit
    @bullets.each { |bullet|
      if bullet.alive? == true
        pos_vector,vel_vector=Ftor.new(0,0),Ftor.new(0,0)
        
        pos_vector.x,pos_vector.y,vel_vector.x,vel_vector.y=
        bullet.pos_vector.x,bullet.pos_vector.y,bullet.velocity_vector.x,bullet.velocity_vector.y
        
        pos_vector = pos_vector+vel_vector
        x1,y1=pos_vector.x,pos_vector.y
        pos_vector = pos_vector+vel_vector
        x2,y2=pos_vector.x,pos_vector.y
        
        @surface.draw_line_a([x1,y1],[x2,y2],[255,255,255,255])
      else
        @bullets.delete(bullet)
      end  
      @surface.blit(onto,[0,0],@ob_rect)
     # @surface.update()
    }
    
    
  end
  
  def append(bullet)
    @bullets << bullet
  end
  
  
  
end