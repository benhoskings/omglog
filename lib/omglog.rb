# coding: utf-8

module Omglog
  VERSION = '0.0.10'

  def run_on system

    if ARGV.length > 1
      abort "Usage: $ omglog [path]"
    elsif ARGV.length == 1
      Dir.chdir(ARGV.shift)
    end

    Omglog::Base.run
    on_terminal_resize { Omglog::Base.run }
    system.on_change { Omglog::Base.run }
  end
  module_function :run_on

  def on_terminal_resize &block
    rendering = true
    trap("WINCH") {
      # A dragging resize fires lots of WINCH events; this throttles the redraw
      # and should cause it to (usually) line up with the final dimensions.
      if rendering
        rendering = false
        sleep 0.5
        yield
        rendering = true
      end
    }
  end
  module_function :on_terminal_resize

  class Base
    CLEAR = "\n----\n"
    YELLOW, BLUE, GREY, HIGHLIGHT = '0;33', '0;34', '0;90', '1;30;47'
    SHORTEST_MESSAGE = 12
    LOG_CMD = %{git log --all --date-order --graph --color --pretty="format: \2%h\3\2%d\3\2 %s\3\2 %an, %ar\3"}
    LOG_REGEX = /(.*)\u0002(.*)\u0003\u0002(.*)\u0003\u0002(.*)\u0003\u0002(.*)\u0003/
    GRAPH, REF, DECS, MSG, AUTHOR =  0, 1, 2, 3, 4

    def self.log_cmd
      @log_cmd ||= [LOG_CMD].concat(ARGV).join(' ')
    end

    def self.run
      rows, cols = `tput lines; tput cols`.scan(/\d+/).map(&:to_i)
      `#{log_cmd} -#{rows}`.tap {|log|
        log_lines = Array.new(rows, '')
        log_lines.unshift *log.split("\n")

        print CLEAR + log_lines[0...(rows - 1)].map {|l|
          commit = l.scan(LOG_REGEX).flatten.map(&:to_s)
          commit.any? ? render_commit(commit, cols) : l
        }.join("\n") + "\n" + "\e[#{GREY}mupdated #{Time.now.strftime("%a %H:%M:%S")}\e[m ".rjust(cols + 8)
      }
    end

    def self.render_commit commit, cols
      row_highlight = commit[2][/[^\/]HEAD\b/] ? HIGHLIGHT : YELLOW
      [nil, row_highlight, BLUE, '', GREY].map {|c| "\e[#{c}m" if c }.zip(
        arrange_commit(format_commit(commit), cols)
      ).join + "\e[m"
    end

    def self.format_commit commit
      [
        commit[GRAPH].chomp!(' '),
        commit[REF],
        commit[DECS],
        commit[MSG],
        commit[AUTHOR].sub(/(\d+)\s(\w)[^\s]+ ago/, '\1\2 ago').sub(/^ (\w)\w+\s(\w).*,/, ' \1\2,')
      ].each {|c| c.gsub(/\t+/, ' ') }
    end

    def self.arrange_commit commit, cols
      fixed_part = [commit[GRAPH], commit[REF], commit[AUTHOR]].join.gsub(/\e\[[\d;]*m/, '').length
      decoration_max = [cols - (fixed_part + [commit[MSG].length, SHORTEST_MESSAGE].min), SHORTEST_MESSAGE].max
      decoration_length = [commit[DECS].length, decoration_max].min
      msg_max = [cols - (fixed_part + decoration_length), SHORTEST_MESSAGE].max
      msg_length = [commit[MSG].length, msg_max].min

      decs = (commit[DECS].empty? ? '' : truncate(commit[DECS], decoration_length))
      msg = truncate(commit[MSG], msg_length).ljust(msg_max)

      [commit[GRAPH], commit[REF], decs, msg, commit[AUTHOR]]
    end

    def self.truncate string, length
      if string.length > length
        string[0...(length - 1)] + '…'
      else
        string
      end
    end
  end
end
