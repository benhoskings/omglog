##Description

Start `omglog` in a git repository. It will watch the `.git` directory for changes are re-render the repository graph.


##Requirement

Ruby version that supports file system watcher. _JRuby is currently not supported._


##Install

    $ gem install omglog


## Use with RVM

If you are using RVM and using unsupported flavors of ruby, the following will allow you to configure a wrapper for `omglog` that will always launch it using a suppored version of ruby and the gemset of your choosing.

_This example is using ruby-2.2.0 and the @global gemset._

**Install to global gemset**

    $ rvm install ruby-2.2.0
    $ rvm use ruby-2.2.0
    $ rvm @global do gem install omglog
    $ rvm wrapper ruby-2.2.0@global launch omglog

After creating the wrapper, to launch `omglog` via the wrapper run:

    $ launch_omglog

_OR, create an alias for convenience..._

Edit your `.zshrc` or `.bashrc` and add:

    alias omgl='launch_omglog'
