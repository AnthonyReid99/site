FlowRouter.route '/post/:id',
  name: 'Blog'
  meta:
    title: "Blog"

  subscriptions: ->
    this.register 'PublishedBlogPosts', Meteor.subscribe('PublishedBlogPosts')
    this.register 'BlogPostLabels', Meteor.subscribe('BlogPostLabels')
    this.register 'Labels', Meteor.subscribe('Labels')
    this.register 'Users', Meteor.subscribe('Users')

  action: ->
    BlazeLayout.render 'MainLayout',
      content: 'Blog'


Template.Blog.helpers

  'posts': ->
    q =
      status: 'published'
    options =
      sort:
        createdAt: -1
    Collection.BlogPost.find q, options


Template.Article.helpers

  'author': ->
    Meteor.users.findOne(@creator)?.username or 'unknown'

  'postedOnDate': ->
    moment(@createdAt).format 'MMM D YYYY @ h:mA'

  'label': ->
    Collection.Label.findOne @labelId
