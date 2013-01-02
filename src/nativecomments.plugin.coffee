# Export
module.exports = (BasePlugin) ->
	# Define
	class NativeCommentsPlugin extends BasePlugin
		# Name
		name: 'nativecomments'

		# Extend Template Data
		# Add our form to our template data
		extendTemplateData: ({templateData}) ->
			templateData.getCommentBlock = -> """
				<section class="comments">

					<div class="comments-new">
						<h2>New Comment</h2>

						<p>Enter your comment here. Markdown supported.</p>

						<form action="/comment" method="POST">
							<textarea name="comment"></textarea>
							<input type="submit" value="Post Comment" />
						</form>
					</div>

					<div class="comments-list">
						<h2>Comments</h2>
						<% if @getCollection('comments').length is 0: %>
							<p>No comments yet</p>
						<% else: %>
							<ul>
								<% for comment in @getCollection('comments').toJSON(): %>
									<li>
										<a href="<%=comment.url%>"><%=comment.title or comment.contentRenderedWithoutLayouts%></a>
									</li>
								<% end %>
							</ul>
						<% end %>
					</div>

				</section>
				""".replace(/^\s+|\n\s*|\s+$/g,'')

			# Chain
			@


		# Extend Collections
		# Create our live collection for our comments
		extendCollections: ->
			docpad = @docpad
			database = docpad.getDatabase()
			comments = database.findAllLive({relativePath: $startsWith: 'comments'},[date:-1])
			docpad.setCollections({comments})
			@


		# Server Extend
		# Add our handling for posting the comment
		serverExtend: (opts) ->
			# Prepare
			{server} = opts
			docpad = @docpad
			database = docpad.getDatabase()

			# Comment Handing
			server.post '/comment', (req,res,next) ->
				# Prepare
				commentBody = req.body.comment
				date = new Date()
				ctime = date.getTime()
				filename = "#{ctime}.html.md"
				fileRelativePath = "comments/#{filename}"
				fileFullPath = docpad.config.documentsPaths[0]+"/#{fileRelativePath}"
				opts =
					attributes:
						ctime: ctime
						filename: filename
						relativePath: fileRelativePath
						fullPath: fileFullPath
						meta:
							title: "Comment at #{date.toString()}"
							layout: 'default'

				# Render
				docpad.renderData commentBody, opts, (err,result,comment) ->
					# Check
					return next(err)  if err

					# Add to database
					database.add(comment)

					# Render
					docpad.action 'generate', {reset:false}, (err) ->
						# Check
						return next(err)  if err

						# Update browser
						res.redirect('back')

			# Done
			@

