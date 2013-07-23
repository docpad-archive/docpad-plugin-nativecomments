# Export
module.exports = (BasePlugin) ->
	# Define
	class NativeCommentsPlugin extends BasePlugin
		# Name
		name: 'nativecomments'

		# Config
		config:
			collectionName: 'comments'
			relativeDirPath: 'comments'
			postUrl: '/comment'
			extension: '.html.md'
			blockHtml: """
				<section class="comments">

					<div class="comments-new">
						<h2>New Comment</h2>

						<p>Enter your comment here. Markdown supported.</p>

						<form action="/comment" method="POST">
							<input type="hidden" name="for" value="<%= @document.relativeBase %>" />
							<label>Author: <input type="author" name="author" /></label>
							<label>Title: <input type="text" name="title" /></label>
							<label>Body: <textarea name="body"></textarea></label>
							<input type="submit" value="Post Comment" />
						</form>
					</div>

					<div class="comments-list">
						<h2>Comments</h2>
						<% if @getComments().length is 0: %>
							<p>No comments yet</p>
						<% else: %>
							<ul>
								<% for comment in @getComments().toJSON(): %>
									<li>
										<a href="<%=comment.url%>"><%=comment.title or comment.contentRenderedWithoutLayouts%></a>
									</li>
								<% end %>
							</ul>
						<% end %>
					</div>

				</section>
				""".replace(/^\s+|\n\s*|\s+$/g,'')

		# Extend Template Data
		# Add our form to our template data
		extendTemplateData: ({templateData}) ->
			# Prepare
			plugin = @
			docpad = @docpad

			# getCommentsBlock
			templateData.getCommentsBlock = ->
				@referencesOthers()
				return plugin.getConfig().blockHtml

			# getComments
			templateData.getComments = ->
				return docpad.getCollection(plugin.getConfig().collectionName).findAll(for: @document.relativeBase)

			# Chain
			@


		# Extend Collections
		# Create our live collection for our comments
		extendCollections: ->
			# Prepare
			config = @getConfig()
			docpad = @docpad
			database = docpad.getDatabase()

			# Create the collection
			comments = database.findAllLive({relativeDirPath: $startsWith: config.relativeDirPath}, [date:-1])

			# Set the collection
			docpad.setCollection(config.collectionName, comments)

			# Chain
			@


		# Server Extend
		# Add our handling for posting the comment
		serverExtend: (opts) ->
			# Prepare
			{server} = opts
			plugin = @
			docpad = @docpad
			database = docpad.getDatabase()

			# Comment Handing
			server.all @getConfig().postUrl, (req,res,next) ->
				# Prepare
				config = plugin.getConfig()
				now = new Date(req.body.date or null)
				nowTime = now.getTime()
				nowString = now.toString()
				redirect = req.body.redirect ? req.query.redirect ? 'back'

				# Prepare
				documentAttributes =
					data: req.body.body or ''
					meta:
						title: req.body.title or "Comment at #{nowString}"
						for: req.body.for or ''
						author: req.body.author or ''
						date: now
						fullPath: docpad.config.documentsPaths[0]+"/#{config.relativeDirPath}/#{nowTime}#{config.extension}"

				# Create document from attributes
				document = docpad.createDocument(documentAttributes)

				# Inject helper
				config.injectDocumentHelper?.call(me, document)

				# Add it to the database
				database.add(document)

				# Listen for regeneration
				docpad.once 'generateAfter', ->
					# Check
					# return next(err)  if err

					# Update browser
					if redirect is 'back'
						res.redirect('back')
					else if redirect is 'document'
						res.redirect(document.get('url'))
					else
						res.json(documentAttributes)

					# No need to call next here as res.send/redirect will do it for us

				# Write source which will trigger the regeneration
				document.writeSource {cleanAttributes:true}, (err) ->
					# Check
					return next(err)  if err

			# Done
			@

