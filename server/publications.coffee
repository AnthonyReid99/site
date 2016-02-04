Meteor.publish 'PublishedBlogPosts', ->
  Collection.BlogPost.find
    status: 'published'

Meteor.publish 'BlogPostLabels', ->
  Collection.BlogPostLabel.find()

Meteor.publish 'BlogPosts', ->
  Collection.BlogPost.find
    creator: @userId

Meteor.publish 'Users', ->
  Meteor.users.find()

Meteor.publish 'Labels', ->
  Collection.Label.find()

Meteor.publish 'PublishedProjects', ->
  Collection.Project.find
    status: 'published'

Meteor.publish 'Projects', ->
  Collection.Project.find()

Meteor.publish 'ProjectLabels', ->
  Collection.ProjectLabel.find()
