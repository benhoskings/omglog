##Description

Start `omglog` in a git repository. It will watch the `.git` directory for changes are re-render the repository graph.


##Requirements

Ruby version that supports fsevents on OS X, or inotify on linux. _JRuby is not currently supported._


##Install

    $ gem install omglog


##Usage

In terminal, run from the root a git repository:

    $ omglog


## Use with RVM

If you are using RVM and using unsupported flavors of ruby, the following will allow you to configure a wrapper for `omglog` that will always launch it using a suppored version of ruby and the gemset of your choosing.

_This example is using ruby-2.2.0 and the @global gemset._

**Install to global gemset and generate wrapper**

    $ rvm install ruby-2.2.0
    $ rvm use ruby-2.2.0
    $ rvm @global do gem install omglog
    $ rvm wrapper ruby-2.2.0@global --no-prefix omglog

_Make sure you don't have the `omglog` gem installed in any other gemsets, otherwise they may take precendence over this wrapper._
