# Native Comments Plugin for DocPad
Adds support for native comments to [DocPad](https://docpad.org).


## Install

1. Install the Plugin

  ```
  npm install --save --force docpad-plugin-nativecomments
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
