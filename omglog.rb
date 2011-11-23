require 'rb-fsevent'

LOG_CMD = %{git log --all --graph --pretty="format:%h%d \2%s\3 \2%an,\3 \2%ar\3"}

LOG_REGEX = %r{
    ([*|/\\_\-.\s]+) # graph
 \s ([\w]{7,40})     # ref
(\s \(.*\))?         # decorations
 \s \u0002(.*)\u0003 # message
 \s \u0002(.*)\u0003 # author
 \s \u0002(.*)\u0003 # timestamp
}x

CLEAR = "\e[2J"

# example `git log` output
# "*   \e[33m7c3240d\e[34m (HEAD, origin/master, origin/HEAD, master)\e[m Merge branch 'versions' \e[37m Ben Hoskings, 11 minutes ago\e[m"
# "*   7c3240d  (HEAD, origin/master, origin/HEAD, master) 'Merge branch 'versions'' 'Ben Hoskings' '16 minutes ago'"

def omglog
  rows = (`tput lines`.to_i * 0.7).floor
  `#{LOG_CMD} -#{rows}`.tap {|log|
    STDOUT.puts CLEAR + log
  }
end

