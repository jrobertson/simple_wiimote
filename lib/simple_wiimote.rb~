#!/usr/bin/env ruby

# file: simple_wiimote.rb

require 'cwiid'

class WiiMote  attr_accessor :active  end

class SimpleWiimote

  attr_accessor :terminator, :events, :led, :rumble

  def initialize()

    puts 'Put Wiimote in discoverable mode now (press 1+2)...'
    
    @wiimote = WiiMote.new
    @wiimote.rpt_mode = WiiMote::RPT_BTN | WiiMote::RPT_ACC
    @wiimote.active = false
    
    @events = {
      WiiMote::BTN_PLUS =>  -> {puts 'you pressed plus'},
      WiiMote::BTN_UP   =>  -> {puts 'you pressed up'},
      WiiMote::BTN_DOWN =>  -> {puts 'you pressed down'},
      WiiMote::BTN_RIGHT => -> {puts 'you pressed right'},
      WiiMote::BTN_LEFT =>  -> {puts 'you pressed left'},
      WiiMote::BTN_HOME =>  -> {puts 'you pressed home'},
      WiiMote::BTN_MINUS => -> {puts 'you pressed minus'},
      WiiMote::BTN_A    =>  -> {puts 'you pressed a'},
      WiiMote::BTN_B    =>  -> {puts 'you pressed b'},
      WiiMote::BTN_1    =>  -> {puts 'you pressed 1'},
      WiiMote::BTN_2    =>  -> {puts 'you pressed 2'}
    }

    @terminator = WiiMote::BTN_A
  end

  def activate()
    
    begin
      @wiimote.get_state
      @wiimote.active = true
      yield(@wiimote) if block_given?  

      if @wiimote.buttons > 0  then
	r = @events[@wiimote.buttons]
	sleep 0.2
	r.call  if r
      end
    end until (@wiimote.buttons & @terminator ) != 0  || !@wiimote.active 
  end

  def led=(val)      @led    = @wiimote.led    = val   end
  def rumble=(bool)  @rumble = @wiimote.rumble = bool  end
  def close()        @wiimote.close  end
end
