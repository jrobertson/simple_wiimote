#Introducing the Simple Wiimote gem version 0.3

In this version you are expected to create your own class which inherits from the SimpleWiimote class. e.g.

    require 'simple_wiimote'

    class MyWiimote < SimpleWiimote

    end

    mwm = MyWiimote.new 
    mwm.activate # to deactivate buttons 1 + 2 are pressed

output:

    button right pressed
    button left pressed
    button down pressed
    button up pressed
    button b pressed 
    button b down: [132, 104, 115]
    button b down: [132, 104, 115]
    button b down: [132, 104, 115]
    button b up
    button a pressed
    button 1 pressed
    button a pressed
    button home pressed
    button b pressed
    button b down: [129, 99, 128]
    button b down: [129, 99, 128]
    button b down: [129, 99, 128]
    button b down: [129, 99, 128]
    button b down: [129, 99, 128]
    button b down: [131, 99, 127]
    button b down: [132, 99, 127]
    button b down: [132, 99, 127]
    button b down: [132, 99, 127]
    button b down: [132, 99, 127]
    button b down: [127, 98, 127]
    button b down: [126, 97, 126]
    button b down: [126, 97, 126]
    button b down: [126, 97, 126]
    button b down: [125, 97, 125]
    button b down: [123, 96, 125]
    button b down: [123, 96, 125]
    button b down: [123, 96, 125]
    button b down: [123, 96, 125]
    button b down: [123, 96, 125]
    button b down: [121, 95, 123]
    button b down: [121, 95, 120]
    button b down: [121, 95, 120]
    button b down: [121, 95, 120]
    button b down: [121, 95, 120]
    button b down: [122, 96, 118]
    button b down: [123, 96, 116]
    button b down: [123, 96, 116]
    button b down: [123, 96, 116]
    button b down: [123, 96, 116]
    button b down: [124, 96, 116]
    button b down: [124, 97, 117]
    button b down: [124, 97, 117]
    button b down: [124, 97, 117]
    button b down: [124, 97, 117]
    button b down: [124, 97, 117]
    button b down: [124, 97, 117]
    button b down: [124, 97, 117]
    button b down: [124, 97, 117]
    button b up
    button 1 pressed
    button 2 pressed
    button 1 pressed
    button 2 pressed


    mwm.led = 1
    mwm.led = 0
    mwm.rumble = true; sleep 0.2; mwm.rumble = false

    def mwm.on_btn_plus_press(wm) puts Time.now end
    mwm.activate


output:

    button left pressed
    button right pressed
    2013-01-20 23:43:26 +0000
    button 2 pressed
    button 1 pressed


Each button has 3 events: on_btn_[buttonid]_press, on_btn_[buttonid]_down, and on_btn_[buttonid]_up. The down and up events are useful when you want to hold down a button while capturing data from the accelarometer. Each default button event can overridden with your own code.

## Resources

* [jrobertson/simple_wiimote](https://github.com/jrobertson/simple_wiimote)[Github.com]

