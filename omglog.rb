require 'rb-fsevent'

LOG_CMD = %{git log --all --graph --pretty="format:%h%d \2%an,\3 \2%ar\3 \2%s\3"}

LOG_REGEX = %r{
    ([*|/\\_\-.\s]+) # graph
 \s ([\w]{7,40})     # ref
(\s \(.*\))?         # decorations
 \s \u0002(.*)\u0003 # author
 \s \u0002(.*)\u0003 # timestamp
 \s \u0002(.*)\u0003 # message
}x

CLEAR = "\e[2J"

# example `git log` output
# "*   \e[33m7c3240d\e[34m (HEAD, origin/master, origin/HEAD, master)\e[m Merge branch 'versions' \e[37m Ben Hoskings, 11 minutes ago\e[m"
# "*   7c3240d  (HEAD, origin/master, origin/HEAD, master) 'Merge branch 'versions'' 'Ben Hoskings' '16 minutes ago'"

def omglog
  `#{LOG_CMD} -$(tput lines)`.tap {|log|
    cols = `tput cols`.chomp.to_i
    log.split("\n").map {|l|
      render_commit l.scan(LOG_REGEX).flatten.map(&:to_s), cols
    }
  }
end

def render_commit commit, cols
  length = commit.map(&:length).inject(&:+) + commit.length - 1
  puts "#{length}: #{commit.inspect}"
end

omglog
