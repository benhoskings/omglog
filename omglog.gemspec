Gem::Specification.new do |s|
  s.name        = 'omglog'
  s.version     = '0.0.12'
  s.summary     = "Live git logging using fseventsd or inotify."
  s.description = "Live git logging using fseventsd or inotify. omg!"
  s.license     = 'BSD'
  s.authors     = ["Ben Hoskings"]
  s.email       = 'ben@hoskings.net'
  s.files       = `git ls-files bin/ lib/`.split("\n")
  s.executables = ['omglog']
  s.homepage    = 'http://github.com/benhoskings/omglog'

  s.add_dependency 'rb-fsevent', '~> 0.9'
  s.add_dependency 'rb-inotify', '~> 0.8'
end
