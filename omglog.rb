# coding: utf-8

require 'rb-fsevent'

class Object; def tapp; tap { puts inspect } end end

CLEAR = "\e[2J\e[H"
YELLOW, BLUE, GREY = 33, 34, 37
SHORTEST_MESSAGE = 12
LOG_CMD = %{git log --all --date-order --graph --color --pretty="format:\2 %h\3\2%d\3\2 %an, %ar\3\2 %s\3"}
LOG_REGEX = /(.*)\u0002(.*)\u0003\u0002(.*)\u0003\u0002(.*)\u0003\u0002(.*)\u0003/

# example `git log` output
# "*   \e[33m7c3240d\e[34m (HEAD, origin/master, origin/HEAD, master)\e[m Merge branch 'versions' \e[37m Ben Hoskings, 11 minutes ago\e[m"
# "*   7c3240d  (HEAD, origin/master, origin/HEAD, master) 'Merge branch 'versions'' 'Ben Hoskings' '16 minutes ago'"

def omglog
  rows, cols = `tput lines; tput cols`.scan(/\d+/).map(&:to_i)
  `#{LOG_CMD} -#{rows}`.tap {|log|
    print CLEAR + log.split("\n")[0...(rows - 1)].map {|l|
      commit = l.scan(LOG_REGEX).flatten.map(&:to_s)
      commit.any? ? render_commit(commit, cols) : l
    }.join("\n") + "\n" + "\e[#{GREY}mupdated #{Time.now.strftime("%a %H:%M:%S")}\e[m ".rjust(cols + 8)
  }
end

def render_commit commit, cols
  [nil, YELLOW, BLUE, '', GREY].map {|c| "\e[#{c}m" if c }.zip(
    arrange_commit(commit, cols)
  ).join + "\e[m"
end

def arrange_commit commit, cols
  commit[0].chomp!(' ')
  commit[-2].sub!(/(\d+)\s(\w)[^\s]+ ago/, '\1\2 ago')
  room = [cols - [commit[0].gsub(/\e\[[\d;]*m/, ''), commit[1..-2]].flatten.map(&:length).inject(&:+), SHORTEST_MESSAGE].max
  commit.tap {|commit|
    commit[3, 0] = if commit[-1].length > room
      commit.pop[0...(room - 1)] + '…'
    else
      commit.pop
    end
  }
end

def on_change &block
  FSEvent.new.tap {|fsevent|
    fsevent.watch('.git', &block)
    fsevent.run
  }
end

abort("Run omglog at the root of the git repo you'd like to watch.") if (ARGV & %w[-h --help help]).any?
abort("The current directory doesn't look like the root of a git repo.") unless File.directory?('.git')
omglog
on_change { omglog }
