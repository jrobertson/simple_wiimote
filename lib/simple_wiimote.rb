#!/usr/bin/env ruby

# file: simple_wiimote.rb

require 'pinx'
require 'cwiid'


class Led < PinX  
  
  def initialize(parent)
    @parent = parent
  end
  
  def state()
    @on ? 1 : 0
  end
  
  protected

  # set val with 0 (off) or 1 (on)
  #
  def set_pin(val)

    super(val)
    @parent.on_ledchange
      
  end  
end

class WiiMote
  attr_accessor :active
end

class SimpleWiimote

  attr_accessor :terminator, :led, :rumble

  def initialize()

    puts 'Put Wiimote in discoverable mode now (press 1+2)...'
    
    @wiimote = WiiMote.new
    @wiimote.rpt_mode = WiiMote::RPT_BTN | WiiMote::RPT_ACC
    @wiimote.active = false
            
    btn_states = %w(press down up)
    buttons = %w(2 1 b a minus void1 void2 home left right down up plus)
    
    @events = buttons.inject({}) do |r,x|
      
      h = btn_states.inject({}) do |r,state|
        
        label = ("on_button" + state).to_sym

        event = lambda do |wm| 
          method_name = ("on_btn_%s_%s" % [x, state]).to_sym
          method(method_name).call(wm) if self.respond_to? method_name
        end

        r.merge label => event
      end
      r.merge x => h
    end

    @events['void1'] = @events['void2'] = nil
    @terminator = ['1','2']    
    @led = 4.times.map { Led.new self}
    
  end

  def activate()
    
    previously_pressed, pressed = [], []
    
    button = {
        press: proc   {|x, wiimote| x[:on_buttonpress].call wiimote},
         down: lambda {|x, wiimote| x[:on_buttondown].call  wiimote},
           up: proc   {|x, wiimote| x[:on_buttonup].call    wiimote}
    }
    
    begin
      
      @wiimote.get_state
      @wiimote.active = true
      sleep 0.01
      yield(@wiimote) if block_given?  
      sleep 0.01

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
          button[:press].call(@events[x], @wiimote)
        end
        
        pressed.each do |x|
          button[:down].call(@events[x], @wiimote)
        end        
        
        expired_keypresses.each do |x| 
          button[:up].call(@events[x], @wiimote)
        end

        pressed = []
      else
        
        if previously_pressed.length > 0 then
          
          expired_keypresses = previously_pressed

          expired_keypresses.each do |x|
            button[:up].call(@events[x], @wiimote)
          end
          
          previously_pressed, expired_keypressed, pressed = [], [], []    
        end
      end

    end until ( not @wiimote.active )
    
    on_deactivated()
    
  end


  def rumble=(bool)  @rumble = @wiimote.rumble = bool  end
  def close()        @wiimote.close  end
    
  def on_ledchange()
    @wiimote.led = @led.map(&:state).reverse.join.to_i(2)
  end
    
  protected
    
  def on_btn_2_press(wm)      puts 'button 2 pressed'     end
  def on_btn_1_press(wm)      puts 'button 1 pressed'     end
  def on_btn_b_press(wm)      puts 'button b pressed'     end
  def on_btn_a_press(wm)      puts 'button a pressed'     end
  def on_btn_minus_press(wm)  puts 'button minus pressed' end
  def on_btn_void1_press(wm)  puts 'button void1 pressed' end
  def on_btn_void2_press(wm)  puts 'button void2 pressed' end
  def on_btn_home_press(wm)   puts 'button home pressed'  end
  def on_btn_left_press(wm)   puts 'button left pressed'  end
  def on_btn_right_press(wm)  puts 'button right pressed' end
  def on_btn_down_press(wm)   puts 'button down pressed'  end
  def on_btn_up_press(wm)     puts 'button up pressed'    end
  def on_btn_plus_press(wm)   puts 'button plus pressed'  end
  
  def on_btn_b_up(wm)         puts 'button b up'          end
    
  def on_btn_b_down(wm)
    puts 'button b down: ' + wm.acc.inspect       
  end
  
  def on_deactivated()
    puts 'wiimote deactivated'
  end

end