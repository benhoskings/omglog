require 'rb-fsevent'

LOG_CMD = 'git log --all --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
CLEAR = "\e[2J"

abort("Run with a single argument (the directory to omglog).") unless ARGV.length == 1

def omglog
  rows = (`tput lines`.to_i * 0.7).floor
  `#{LOG_CMD} -#{rows}`.tap {|log|
    STDOUT.puts CLEAR + log
  }
end

FSEvent.new.tap {|fsevent|
  fsevent.watch(File.join(ARGV[0], '.git')) {|directories|
    omglog
  }
  fsevent.run
}
