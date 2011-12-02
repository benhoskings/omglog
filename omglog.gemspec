Gem::Specification.new do |s|
  s.name        = 'omglog'
  s.version     = '0.0.1'
  s.summary     = "Realtime git logging using fseventsd."
  s.description = "Realtime git logging using fseventsd. omg!"
  s.authors     = ["Ben Hoskings"]
  s.email       = 'ben@hoskings.net'
  s.files       = ["bin/omglog"]
  s.executables = ['omglog']
  s.homepage    = 'http://github.com/benhoskings/omglog'

  s.add_dependency 'rb-fsevent', '~> 0.4.3'
end
