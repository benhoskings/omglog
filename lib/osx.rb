require 'rb-fsevent'

module Omglog
  class OSX
    def self.on_change &block
      fsevent = FSEvent.new
      fsevent.watch('.git', &block)
      fsevent.run
    end
  end
end
