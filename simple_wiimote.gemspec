Gem::Specification.new do |s|
  s.name = 'simple_wiimote'
  s.version = '0.4.1'
  s.summary = 'Use this gem with the Wii remote to handle button presses as well as to individually set LEDs on or off, or to make the device rumble.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/simple_wiimote.rb']
  s.add_runtime_dependency('cwiid', '~> 0.1', '>=0.1.3') 
  s.signing_key = '../privatekeys/simple_wiimote.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/simple_wiimote'
  s.required_ruby_version = '>= 2.1.2'
end
