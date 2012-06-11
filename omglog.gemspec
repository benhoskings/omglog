Gem::Specification.new do |s|
  s.name        = 'omglog'
  s.version     = '0.0.7'
  s.summary     = "Realtime git logging using fseventsd."
  s.description = "Realtime git logging using fseventsd. omg!"
  s.authors     = ["Ben Hoskings"]
  s.email       = 'ben@hoskings.net'
  s.files       = `git ls-files bin/ lib/`.split("\n")
  s.executables = ['omglog']
  s.homepage    = 'http://github.com/benhoskings/omglog'

  s.add_dependency 'rb-fsevent', '~> 0.9.0'
  s.add_dependency 'rb-inotify', '~> 0.8.8'
end
