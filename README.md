#Using Simple_wiimote to test the Wiimote in Ruby

    require 'simple_wiimote'

    swm.led = 1

    swm.rumble = true #=> true 
    sleep 0.2
    swm.rumble = false #=> false 

    swm.activate # deactivate by pressing button A

output:

    you pressed right
    you pressed left
    you pressed up
    you pressed down
    you pressed b
    you pressed minus
    you pressed home
    you pressed plus
    you pressed 1
    you pressed 2
    you pressed 2
    you pressed b
    you pressed b
    you pressed b
    you pressed a

swm.activate # deactive by pressing button B

output:

    you pressed plus
    you pressed minus
    you pressed minus
    you pressed home
    you pressed b


Testing acceleration

    swm.activate {|wiimote| puts "[ %3d, %3d, %3d ]" % wiimote.acc}

output:

    ...
    [ 115, 115, 145 ]
    [ 115, 115, 145 ]
    [ 116, 114, 145 ]
    [ 116, 114, 145 ]
    [ 116, 114, 145 ]
    [ 117, 115, 146 ]
    [ 117, 115, 146 ]
    [ 117, 115, 146 ]
    [ 117, 115, 146 ]
    [ 119, 117, 146 ]
    [ 119, 117, 146 ]
    [ 119, 117, 146 ]
    [ 115, 117, 143 ]
    [ 115, 117, 143 ]
    [ 115, 117, 143 ]
    [ 116, 118, 143 ]
    you pressed b


Testing termination within the block

    swm.activate {|wiimote| puts "[ %3d, %3d, %3d ]" % wiimote.acc;  wiimote.active = false}
    #=> [ 138, 118, 135 ]

    swm.close # observe the Wiimote has disconnected

## Resources

* [Wii Remote](http://en.wikipedia.org/wiki/Wii_Remote)
* [Introducing the simple_wiimote gem](http://jamesrobertson.eu/snippets/2011/12/16/0101hrs.html)
* [jrobertson/simple_wiimote](https://github.com/jrobertson/simple_wiimote)

wiimote simple_wiimote gem wii events
