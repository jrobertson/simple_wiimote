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
    def @wiimote.active=(bool)
      @active = bool
    end

    @wiimote.active = false
    @events = {}
    @events[WiiMote::BTN_PLUS] = -> {puts 'you pressed plus'}
    @events[WiiMote::BTN_UP] =   -> {puts 'you pressed up'}
    @events[WiiMote::BTN_DOWN] = -> {puts 'you pressed down'}
    @events[WiiMote::BTN_RIGHT]  =-> {puts 'you pressed right'}
    @events[WiiMote::BTN_LEFT] = -> {puts 'you pressed left'}
    @events[WiiMote::BTN_HOME] = -> {puts 'you pressed home'}
    @events[WiiMote::BTN_MINUS] = -> {puts 'you pressed minus'}
    @events[WiiMote::BTN_A] = -> {puts 'you pressed a'}
    @events[WiiMote::BTN_B] = -> {puts 'you pressed b'}
    @events[WiiMote::BTN_1] = -> {puts 'you pressed 1'}
    @events[WiiMote::BTN_2] = -> {puts 'you pressed 2'}

    @terminator = WiiMote::BTN_A
  end

  def activate()
    
    begin
      @wiimote.get_state
      @wiimote.active = true
      yield(@wiimote) if block_given?  

      old_btn ||= @wiimote.buttons
      if @wiimote.buttons > 0  then
        if @wiimote.buttons != old_btn then
          r = @events[@wiimote.buttons]
          r.call if r
          old_btn = @wiimote.buttons

        else
          sleep 0.2
          old_btn = 0
        end
      end
    end until (@wiimote.buttons & @terminator ) != 0  || !@wiimote.active 
  end

  def led=(val)
    @led = val
    @wiimote.led = val
  end

  def rumble=(bool)
    @rumble = bool
    @wiimote.rumble = bool
  end

  def close()
    @wiimote.close
  end
end
