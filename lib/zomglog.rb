# encoding: utf-8

LOG_CMD = %{git log --all --date-order --graph --pretty="format: \2%h\3\2%d\3\2 %an, %ar\3\2 %s\3" -80}
LOG_REGEX = /(.*)\u0002(.*)\u0003\u0002(.*)\u0003\u0002(.*)\u0003\u0002(.*)\u0003/

class Omglog
  def initialize(dir)
    @dir = dir
  end

  def shell_out
    cmd = %Q{cd #{@dir} && #{LOG_CMD}}
    `#{cmd}`
  end

  def to_hash
    shell_out.split("\n").map { |l|
      commit = l.scan(LOG_REGEX).flatten.map(&:to_s)
      commit.any? ? commit : [l]
    }
  end

  def to_html
    Haml::Engine.new(<<HAML).render(binding)
%html
  %head
    :css
      body {
        #background-color: hsl(200, 57%, 8%);
        #background-color: rgb(29,29,29);
        background-color: hsl(0, 0%, 20%);
        font-family: Menlo;
        font-size: 14px;
        color: hsl(0, 0%, 65%);
      }
      .line span { display: inline-block; }
      .dot {
        -webkit-transform: scaleY(0.8) translateY(1px) scale(1.8);
        color: hsl(0, 0%, 10%);
        text-shadow: 0 1px 1px hsla(0, 100%, 100%, 0.15);
      }
      .graph {
        color: hsl(0, 0%, 12%);
        font-weight: bold;
        -webkit-transform: scaleY(1.1);
        text-shadow: 1px 1px 0 hsla(0, 100%, 100%, 0.15);
      }
      .sha {
        color: hsl(48, 91%, 38%);
        text-shadow: 1px 1px 0 hsla(0, 100%, 0%, 1.0);
      }
      .tags {
        color: rgb(73, 122, 191);
      }
      .author { float: right;
        text-shadow: 1px 1px 0 hsla(0, 100%, 0%, 1.0);
      }
      .message {
        text-shadow: 1px 1px 0 hsla(0, 100%, 0%, 1.0);
      }
      .head {
        background-color: hsl(215, 48%, 44%);
        text-shadow: 1px 1px 0 hsla(0, 0%, 100%, 0.15);
        padding: 1px 0.3em;
        border-radius: 3px;
        color: hsl(0, 0%, 16%);
      }
  %body
    - to_hash.each do |line|
      %div.line
        - line.zip(%w[graph sha tags author message]).each do |v, tag|
          - if !v.empty?
            - if tag == 'graph'
              %span{class: tag}= v.gsub(/\\*/,"<span class='dot'>•</span>")
            - elsif tag == 'tags'
              %span{class: tag}= v.gsub(/HEAD/,"<span class='head'>HEAD</span>")
            - else
              %span{class: tag}= v


HAML
  end
end
