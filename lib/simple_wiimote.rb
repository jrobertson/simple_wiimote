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
      '2'     => -> {puts 'you pressed 2'}, 
      '1'     => -> {puts 'you pressed 1'},
      'b'     => -> {puts 'you pressed b'},
      'a'     => -> {puts 'you pressed a'},
      'minus' => -> {puts 'you pressed minus'},
      'void1' => nil,
      'void2' => nil,
      'home'  => -> {puts 'you pressed home'},
      'left'  => -> {puts 'you pressed left'},
      'right' => -> {puts 'you pressed right'},
      'down'  => -> {puts 'you pressed down'},
      'up'    => -> {puts 'you pressed up'},
      'plus'  => {
        on_buttondown: -> {puts 'you pressed plus'},
        on_buttonup:   -> {puts 'plus button raised'}
      }
    }

    @terminator = ['1','2']
  end

  def activate()
    
    previously_pressed, pressed = [], []
    
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
        pressed = []

        procs1 = {
          Hash: lambda {|x| x[:on_buttondown].call}, 
          Proc: lambda {|x| x.call}
        }

        procs2 = {
          Hash: lambda {|x| x[:on_buttonup].call}, 
          Proc: lambda {|x| }
        }

        new_keypresses.each do |x| 
          procs1[@events[x].class.to_s.to_sym].call(@events[x])
        end
        
        expired_keypresses.each do |x| 
          procs2[@events[x].class.to_s.to_sym].call(@events[x])
        end
        
      else
        
        if previously_pressed.length > 0 then
          
          expired_keypresses = previously_pressed

          expired_keypresses.each do |x|
            procs2[@events[x].class.to_s.to_sym].call(@events[x])
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
