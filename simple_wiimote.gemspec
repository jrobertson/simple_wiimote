Gem::Specification.new do |s|
  s.name = 'simple_wiimote'
  s.version = '0.3.1'
  s.summary = 'simple_wiimote'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('cwiid') 
  s.signing_key = '../privatekeys/simple_wiimote.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
