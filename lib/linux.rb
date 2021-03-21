require 'rb-inotify'

module Omglog
  class Linux
    def self.on_change &block
      notifier = INotify::Notifier.new
      notifier.watch('.git', :modify, :recursive, &block)
      ['TERM', 'INT', 'QUIT'].each do |signal|
        trap(signal) do
          notifier.stop
          exit(0)
        end
      end
      notifier.run
    end
  end
end
