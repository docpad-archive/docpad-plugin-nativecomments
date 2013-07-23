# Native Comments Plugin for [DocPad](https://docpad.org)

[![Build Status](https://secure.travis-ci.org/bevry/docpad-plugin-nativecomments.png?branch=master)](http://travis-ci.org/bevry/docpad-plugin-nativecomments "Check this project's build status on TravisCI")
[![NPM version](https://badge.fury.io/js/docpad-plugin-nativecomments.png)](https://npmjs.org/package/docpad-plugin-nativecomments "View this project on NPM")
[![Gittip donate button](http://badgr.co/gittip/docpad.png)](https://www.gittip.com/docpad/ "Donate weekly to this project using Gittip")
[![Flattr donate button](https://raw.github.com/balupton/flattr-buttons/master/badge-89x18.gif)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](https://www.paypalobjects.com/en_AU/i/btn/btn_donate_SM.gif)](https://www.paypal.com/au/cgi-bin/webscr?cmd=_flow&SESSION=IHj3DG3oy_N9A9ZDIUnPksOi59v0i-EWDTunfmDrmU38Tuohg_xQTx0xcjq&dispatch=5885d80a13c0db1f8e263663d3faee8d14f86393d55a810282b64afed84968ec "Donate once-off to this project using Paypal")

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
	````


## Configure

Some configuration options are available. Check out `src/nativecomments.plugin.coffee` for them.


## History
You can discover the history inside the `History.md` file


## License
Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT License](http://creativecommons.org/licenses/MIT/)
<br/>Copyright &copy; 2013 [Bevry Pty Ltd](http://bevry.me)
