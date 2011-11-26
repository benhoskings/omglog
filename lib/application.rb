require 'rubygems' # disable this for a deployed application
require 'hotcocoa'

framework 'webkit'

class Omglog
  include HotCocoa

  def start
    @path = "."
    application name: 'Omglog' do |app|
      app.delegate = self
      window frame: [100, 100, 500, 500], title: 'Omglog' do |win|
        win << web_view(layout: { expand: [:width, :height] }) do |wv|
          @wv = wv
          draw
        end
        win.will_close { exit }
      end
    end
  end

  # file/open
  def on_open(menu)
    dialog = NSOpenPanel.openPanel
    dialog.canChooseFiles = false
    dialog.canChooseDirectories = true
    dialog.allowsMultipleSelection = false
    if dialog.runModalForDirectory(nil, file:nil) == NSOKButton
    # if we had a allowed for the selection of multiple items
    # we would have want to loop through the selection
      @path = dialog.filenames.first
      draw
    end
  end

  def draw
    cmd = %Q{cd #{@path} && git log --all --date-order --graph --pretty="format: \2%h\3\2%d\3\2 %an, %ar\3\2 %s\3" -100}
    p cmd
    @wv.mainFrame.loadHTMLString <<HTML, baseURL: nil
<!DOCTYPE html>
<html>
  <head>
    <style>
      body { background-color: #CCC; }
    </style>
  </head>
  <body>
    <pre>
#{`#{cmd}`}
    </pre>
  </body>
</html>
HTML
  end

  # file/new
  def on_new(menu)
  end

  # help menu item
  def on_help(menu)
  end

  # This is commented out, so the minimize menu item is disabled
  #def on_minimize(menu)
  #end

  # window/zoom
  def on_zoom(menu)
  end

  # window/bring_all_to_front
  def on_bring_all_to_front(menu)
  end
end

Omglog.new.start
