require 'rb-fsevent'

module Omglog
  class OSX
    def self.on_change &block
      FSEvent.new.tap {|fsevent|
        fsevent.watch('.git', &block)
        fsevent.run
      }
    end
  end
end
