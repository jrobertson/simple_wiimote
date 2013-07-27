Gem::Specification.new do |s|
  s.name = 'simple_wiimote'
  s.version = '0.3.2'
  s.summary = 'simple_wiimote'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('cwiid') 
  s.signing_key = '../privatekeys/simple_wiimote.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/simple_wiimote'
end
