#!/usr/bin/env ruby

# file: simple_wiimote.rb

require 'cwiid'

class WiiMote
  attr_accessor :active
end

class SimpleWiimote

  attr_accessor :terminator, :events, :led, :rumble

  def initialize()

    puts 'Put Wiimote in discoverable mode now (press 1+2)...'
    
    @wiimote = WiiMote.new
    @wiimote.rpt_mode = WiiMote::RPT_BTN | WiiMote::RPT_ACC
    @wiimote.active = false
        
    @events = {
      '2'     => lambda {|wm| puts 'you pressed 2'}, 
      '1'     => lambda {|wm| puts 'you pressed 1'},
      'b'     => lambda {|wm| puts 'you pressed b'},
      'a'     => lambda {|wm| puts 'you pressed a'},
      'minus' => lambda {|wm| puts 'you pressed minus'},
      'void1' => nil,
      'void2' => nil,
      'home'  => lambda {|wm| puts 'you pressed home'},
      'left'  => lambda {|wm| puts 'you pressed left'},
      'right' => lambda {|wm| puts 'you pressed right'},
      'down'  => lambda {|wm| puts 'you pressed down'},
      'up'    => lambda {|wm| puts 'you pressed up'},
      'plus'  => {
        on_buttonpress: lambda {|wm| puts 'you pressed plus'},
        on_buttondown: lambda {|wm| puts wm.acc.inspect},                  
        on_buttonup:   lambda {|wm| puts 'plus button raised'}
      }
    }

    @terminator = ['1','2']
  end

  def activate()
    
    previously_pressed, pressed = [], []
    
    procs_press = {
      Hash: proc {|x, wiimote| x[:on_buttonpress].call(wiimote)}, 
      Proc: proc {|x, wiimote| x.call(wiimote)}
    }
    
    procs_down = {
      Hash: lambda {|x, wiimote| x[:on_buttondown].call(wiimote)}, 
      Proc: proc { }
    }        
    
    procs_up = {
      Hash: proc {|x, wiimote| x[:on_buttonup].call(wiimote)}, 
      Proc: proc { }
    }      
    
    begin
      
      @wiimote.get_state
      @wiimote.active = true
      yield(@wiimote) if block_given?  

      if @wiimote.buttons > 0 then

        val = @wiimote.buttons
        
        @events.keys.reverse.each_with_index do |x,i|

          n = @events.length - 1 - i
          next if x == 32 or x == 64
          
          xval = 2**n
          (val -= xval; pressed << x) if xval <= val

        end
        
        @wiimote.active = (not (@terminator & pressed) == @terminator)
            
        new_keypresses     = pressed            -  previously_pressed
        expired_keypresses = previously_pressed -  pressed

        previously_pressed = pressed      

        new_keypresses.each do |x| 
          procs_press[@events[x].class.to_s.to_sym].call(@events[x], @wiimote)
        end
        
        pressed.each do |x|
          procs_down[@events[x].class.to_s.to_sym].call(@events[x], @wiimote)
        end        
        
        expired_keypresses.each do |x| 
          procs_up[@events[x].class.to_s.to_sym].call(@events[x], @wiimote)
        end

        pressed = []
      else
        
        if previously_pressed.length > 0 then
          
          expired_keypresses = previously_pressed

          expired_keypresses.each do |x|
            procs_up[@events[x].class.to_s.to_sym].call(@events[x], @wiimote)
          end
          
          previously_pressed, expired_keypressed, pressed = [], [], []    
        end
      end

    end until ( not @wiimote.active )
  end

  def led=(val)      @led    = @wiimote.led    = val   end
  def rumble=(bool)  @rumble = @wiimote.rumble = bool  end
  def close()        @wiimote.close  end
end
