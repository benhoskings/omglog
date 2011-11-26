require 'rubygems' # disable this for a deployed application
require 'hotcocoa'

framework 'webkit'

require File.expand_path('../zomglog', __FILE__)

class Omglog
  include HotCocoa

  def start
    @log = Zomglog.new(".") do
      draw
    end
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
      @log.stop
      @log = Zomglog.new(dialog.filenames.first) do
        draw
      end
      draw
    end
  end

  def draw
    @wv.mainFrame.loadHTMLString @log.to_html, baseURL: nil
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
