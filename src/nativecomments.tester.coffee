# Export Plugin Tester
module.exports = (testers) ->
	# PRepare
	{expect} = require('chai')
	superAgent = require('superagent')
	rimraf = require('rimraf')
	pathUtil = require('path')

	# Define My Tester
	class MyTester extends testers.ServerTester
		docpadConfig:
			port: 9779

		cleanup: =>
			# Prepare
			tester = @
			
			# Cleanup native comments
			@test "clean nativecomments", (done) ->
				rimraf pathUtil.join(tester.getConfig().testPath, 'src', 'documents', 'comments'), (err) ->
					done()  # ignore errors

			# Chain
			@

		# Test Create
		testCreate: =>
			# Cleanup
			@cleanup()

			# Forward
			super

			# Chain
			@

		# Test Generate
		testGenerate: testers.RendererTester::testGenerate

		# Custom test for the server
		testServer: (next) ->
			# Prepare
			tester = @
			generated = false

			# Create the server
			super

			###
			# Watch
			@test 'watch', (done) ->
				tester.docpad.action 'watch', (err) ->
					return done(err)  if err
					# Ensure enough time for watching to complete
					setTimeout(
						-> done()
						5*1000
					)
			###

			# Test
			@suite 'nativecomments', (suite,test) ->
				# Prepare
				testerConfig = tester.getConfig()
				docpad = tester.docpad
				docpadConfig = docpad.getConfig()
				plugin = tester.getPlugin()
				pluginConfig = plugin.getConfig()

				# Prepare
				baseUrl = "http://localhost:#{docpadConfig.port}"
				postUrl = "#{baseUrl}/comment"
				now = new Date()
				nowTime = now.getTime()
				nowString = now.toISOString()

				# Post
				test "post a new comment to #{postUrl}", (done) ->
					superAgent
						.post(postUrl)
						.type('json').set('Accept', 'application/json')
						.send(
							body: 'the comment body'
							title: 'the comment title'
							author: 'the comment author'
							for: 'index'
							date: nowTime
							redirect: false
						)
						.timeout(30*1000)
						.end (err,res) ->
							return done(err)  if err

							# Generated
							generated = true

							# Cleanup
							if res.body?.meta?.fullPath
								res.body.meta.fullPath = res.body.meta.fullPath.replace(/.+src\/documents/, 'trimmed')

							# Compare
							actual = res.body
							expected =
								data: 'the comment body',
								meta:
									title: 'the comment title',
									for: 'index',
									author: 'the comment author',
									date: nowString
									mtime: nowString
									fullPath: 'trimmed/comments/'+nowTime+'.html.md'

							# Check
							expect(actual).to.deep.equal(expected)
							done()

				# Force a generate as watching isn't working for plugin tests
				setTimeout(
					-> docpad.action('generate')
					5*1000
				)


			# Cleanup
			@cleanup()

			# Chain
			@
