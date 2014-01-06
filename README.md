# Native Comments Plugin for [DocPad](https://docpad.org)

<!-- BADGES/ -->

[![Build Status](http://img.shields.io/travis-ci/docpad/docpad-plugin-nativecomments.png?branch=master)](http://travis-ci.org/docpad/docpad-plugin-nativecomments "Check this project's build status on TravisCI")
[![NPM version](http://badge.fury.io/js/docpad-plugin-nativecomments.png)](https://npmjs.org/package/docpad-plugin-nativecomments "View this project on NPM")
[![Dependency Status](https://david-dm.org/docpad/docpad-plugin-nativecomments.png?theme=shields.io)](https://david-dm.org/docpad/docpad-plugin-nativecomments)<br/>
[![Gittip donate button](http://img.shields.io/gittip/docpad.png)](https://www.gittip.com/docpad/ "Donate weekly to this project using Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a "Donate once-off to this project using BitCoin")

<!-- /BADGES -->


Adds support for native comments to [DocPad](https://docpad.org)


## Install

1. Install the Plugin

  ```
 docpad install nativecomments
  ```

1. Output the comment form and listing. You may have to change your document's extension (that you place this snippet inside) to `my-document.html.eco.eco` to ensure the inner eco logic within the block is rendered correctly.

  ```
  <%- @getCommentsBlock() %>
  ```

1. Create a `comment` layout that contains something like:

	``` erb
	---
	layout: default
	---

	<article class="comment">
	    <h1 class="comment-title"><%= @document.title %></h1>
	    <span class="comment-author"><%= @document.author %></span>
	    <a href="<%= @getDatabase().get(@document.for)?.get('url') %>" class="comment-for"><%= @getDatabase().get(@document.for)?.get('title') %></a>
	    <div class="comment-body">
	        <%- @content %>
	    </div>
	</article>
	```


## Configure

Some configuration options are available. Check out `src/nativecomments.plugin.coffee` for them.


<!-- HISTORY/ -->

## History
[Discover the change history by heading on over to the `HISTORY.md` file.](https://github.com/docpad/docpad-plugin-nativecomments/blob/master/HISTORY.md#files)

<!-- /HISTORY -->


<!-- CONTRIBUTE/ -->

## Contribute

[Discover how you can contribute by heading on over to the `CONTRIBUTING.md` file.](https://github.com/docpad/docpad-plugin-nativecomments/blob/master/CONTRIBUTING.md#files)

<!-- /CONTRIBUTE -->


<!-- BACKERS/ -->

## Backers

### Maintainers

These amazing people are maintaining this project:

- Benjamin Lupton <b@lupton.cc> (https://github.com/balupton)

### Sponsors

No sponsors yet! Will you be the first?

[![Gittip donate button](http://img.shields.io/gittip/docpad.png)](https://www.gittip.com/docpad/ "Donate weekly to this project using Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a "Donate once-off to this project using BitCoin")

### Contributors

These amazing people have contributed code to this project:

- [Benjamin Lupton](https://github.com/balupton) <b@lupton.cc> — [view contributions](https://github.com/docpad/docpad-plugin-nativecomments/commits?author=balupton)

[Become a contributor!](https://github.com/docpad/docpad-plugin-nativecomments/blob/master/CONTRIBUTING.md#files)

<!-- /BACKERS -->


<!-- LICENSE/ -->

## License

Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT license](http://creativecommons.org/licenses/MIT/)

Copyright &copy; 2013+ Bevry Pty Ltd <us@bevry.me> (http://bevry.me)

<!-- /LICENSE -->


