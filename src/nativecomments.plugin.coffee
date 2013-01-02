# Export
module.exports = (BasePlugin) ->
	# Define
	class NativeCommentsPlugin extends BasePlugin
		# Name
		name: 'nativecomments'

		# Config
		config:
			collectionName: 'comments'
			relativePath: 'comments'
			postUrl: '/comment'
			extension: '.html.md'
			blockHtml: """
				<section class="comments">

					<div class="comments-new">
						<h2>New Comment</h2>

						<p>Enter your comment here. Markdown supported.</p>

						<form action="/comment" method="POST">
							<input type="hidden" name="for" value="<%= @document.id %>" />
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
			{docpad,config} = @

			# getCommentsBlock
			templateData.getCommentsBlock = ->
				@referencesOthers()
				return config.blockHtml

			# getComments
			templateData.getComments = ->
				return docpad.getCollection(config.collectionName).findAll(for:@document.id)

			# Chain
			@


		# Extend Collections
		# Create our live collection for our comments
		extendCollections: ->
			# Prepare
			{docpad,config} = @
			database = docpad.getDatabase()

			# Create the collection
			comments = database.findAllLive({relativePath: $startsWith: config.relativePath},[date:-1])

			# Set the collection
			docpad.setCollection(config.collectionName, comments)

			# Chain
			@


		# Server Extend
		# Add our handling for posting the comment
		serverExtend: (opts) ->
			# Prepare
			{server} = opts
			{docpad,config} = @
			database = docpad.getDatabase()

			# Comment Handing
			server.post config.postUrl, (req,res,next) ->
				# Prepare
				date = new Date()
				dateTime = date.getTime()
				dateString = date.toString()
				filename = "#{dateTime}#{config.extension}"
				fileRelativePath = "#{config.relativePath}/#{filename}"
				fileFullPath = docpad.config.documentsPaths[0]+"/#{fileRelativePath}"

				# Extract
				commentTitle = req.body.title or "Comment at #{dateString}"
				commentBody = req.body.body or ''
				commentFor = req.body.for or ''
				commentAuthor = req.body.author or ''

				# Comment data
				commentData = """
					---
					title: "#{commentTitle}"
					for: "#{commentFor}"
					author: "#{commentAuthor}"
					layout: "comment"
					date: "#{date.toISOString()}"
					---

					#{commentBody}
					"""

				# Package attributes
				attributes =
					data: commentData
					date: date
					filename: filename
					relativePath: fileRelativePath
					fullPath: fileFullPath

				# Create document from attributes
				comment = docpad.ensureDocument(attributes)

				# Load the document
				docpad.loadDocument comment, (err) ->
					# Check
					return next(err)  if err

					# Add to the database
					database.add(comment)

					# Listen for regeneration
					docpad.once 'generateAfter', (err) ->
						# Check
						return next(err)  if err

						# Update browser
						res.redirect('back')

					# Write source which will trigger the regeneration
					comment.writeSource (err) ->
						# Check
						return next(err)  if err


			# Done
			@

