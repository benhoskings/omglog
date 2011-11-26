abort("Usage: macruby app.rb path/to/repo") if ARGV.empty? || (ARGV & %w[-h --help help]).any?
PROJ_ROOT = File.expand_path(ARGV[0])
abort("The current directory doesn't look like the root of a git repo.") unless File.directory?(File.join(PROJ_ROOT, '.git'))
puts "Watching #{PROJ_ROOT} for changes"

framework 'WebKit'
framework 'CoreServices'

class AppDelegate
end

app = NSApplication.sharedApplication
app.delegate = AppDelegate.new
view = WebView.alloc.initWithFrame([0, 0, 1024, 600])
window = NSWindow.alloc.initWithContentRect([0, 0, 1024, 600],
  styleMask:NSTitledWindowMask|NSClosableWindowMask|NSResizableWindowMask, backing:NSBackingStoreBuffered, defer:false)
window.title = PROJ_ROOT
window.delegate = app.delegate
window.setContentView(view)
view.setMediaStyle('screen')
view.setCustomUserAgent 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-us)' +
    'AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10'

window.display
window.orderFrontRegardless

def run_git_log
  output = `cd #{PROJ_ROOT} && git log --all --date-order --graph --color --pretty="format: \2%h\3\2%d\3\2 %an, %ar\3\2 %s\3" -100`
  output.gsub(/\e\[[\d;]*m/,'')
end

frame = view.mainFrame

def render(frame)
  frame.loadHTMLString <<HTML, baseURL: NSURL.URLWithString("http://lol.boats")
<!DOCTYPE html>
<html>
  <head>
    <style>
      body { background-color: #CCC; }
    </style>
  </head>
  <body>
    <pre>
#{run_git_log}
    </pre>
  </body>
</html>
HTML
end

render(frame)

callback = Proc.new do |stream, client_callback_info, number_of_events, paths_pointer, event_flags, event_ids|
  paths_pointer.cast!('*')
  number_of_events.times do |n|
    p [paths_pointer[n], event_flags[n], event_ids[n]]
  end
  render(frame)
end

stream = FSEventStreamCreate(KCFAllocatorDefault, callback, nil, [PROJ_ROOT], KFSEventStreamEventIdSinceNow, 0.0, 0)
FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), KCFRunLoopDefaultMode)
FSEventStreamStart(stream)

app.run
