# Native Comments Plugin for DocPad
Adds support for native comments to [DocPad](https://docpad.org).

Still under construction.



## Install

1. Install the Plugin

  ```
  npm install --save --force docpad-plugin-nativecomments
  ```

1. Output the comment form and listing. You may have to your document's extension (that you place this snippet inside) to `my-document.html.eco.eco` to ensure the inner eco logic within the block is rendered correctly.

  ```
  <%- @getCommentBlock() %>
  ```


## Configure

No configuration yet.


## History
You can discover the history inside the `History.md` file


## License
Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT License](http://creativecommons.org/licenses/MIT/)
<br/>Copyright &copy; 2013 [Bevry Pty Ltd](http://bevry.me)