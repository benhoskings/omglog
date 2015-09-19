# omglog

omglog is a live-updating commandline git log. It uses git's graphing log to display the repo, and refreshes it whenever the repo is changed.

The current head is highlighted, but all branches and heads are shown. They're just pointers to commits, after all; the commit graph is the true shape of the repo.


## Usage

Just `gem install omglog`, and then run `omglog` at the root of the repo you'd like to watch.

To get a feel for how the graph updates, keep an eye on it while you switch to a branch and back to master, make or amend a commit, or fetch a remote.

To exit, send ctrl-C.


## License and Authors

omglog is [BSD-licensed](http://www.linfo.org/bsdlicense.html), as detailed in the [LICENSE file](LICENSE).

Author: [Ben Hoskings](ben@hoskings.net)
