Gem::Specification.new do |s|
  s.name        = 'omglog'
  s.version     = '0.0.8'
  s.summary     = "Realtime git logging using fseventsd."
  s.description = "Realtime git logging using fseventsd. omg!"
  s.license     = 'BSD'
  s.authors     = ["Ben Hoskings"]
  s.email       = 'ben@hoskings.net'
  s.files       = `git ls-files bin/ lib/`.split("\n")
  s.executables = ['omglog']
  s.homepage    = 'http://github.com/benhoskings/omglog'
end
