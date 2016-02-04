Template.Posts.onRendered ->

  $('ul.tabs').tabs()


Template.Posts.helpers

  posts: ->
    Collection.BlogPost.find {},
      sort:
        createdAt: -1

  createdAt: ->
    moment(@createdAt).format 'MMM D YYYY @ h:mA'

  author: ->
    user = Meteor.users.findOne @creator
    user?.username or 'unknown'


Template.Posts.events

  'click .create-post': ->
    if not Meteor.userId()

      $('#login-modal').openModal()
      return

    newPost = new Model.BlogPost
      status: 'draft'
      creator: Meteor.userId()
    newPost.save (err, id) ->
      if err
        console.log('error saving post')
      else
        Session.set 'currentBlogPostId', id
        $('#edit-post.modal').openModal
          ready: =>
            MDEdit.postText?.valueOf().codemirror.getDoc().setValue(newPost.post)

  'click .action-buttons .save': ->
    @set
      post: MDEdit.postText.value()
      title: $('#title').val()
    @save (err, id) ->
      if err
        Materialize.toast 'error saving post', 4000, 'error'
      else
        Materialize.toast 'saved!', 4000

  'click .action-buttons .publish': ->

    @set
      post: MDEdit.postText.value()
      title: $('#title').val()
      status: 'published'
    @save (err, id) ->
      if err
        Materialize.toast 'error saving post', 4000, 'error'
      else
        $('#edit-post.modal').closeModal()
        Materialize.toast 'published!', 4000

  'click .edit-post': (event) ->
    event.stopPropagation()
    Session.set 'currentBlogPostId', @_id
    Session.set 'postLoading', true

    $('#edit-post.modal').openModal
      ready: =>
        MDEdit.postText.valueOf().codemirror.getDoc().setValue(@post)
        Session.set 'postLoading', false

  'click .remove-post': ->

    Session.set 'currentBlogPostId', @_id
    $('#remove-post.modal').openModal()

  'click .confirm-remove': (event) ->
    if @status is 'draft' or (@status is 'published' and $('#verification').val() is @title)
      @blogPostLabels().forEach (blogPostLabel) ->
        blogPostLabel.remove()
      @remove (err, count) ->
        if not err and count is 1
          $('#remove-post.modal').closeModal()
          Materialize.toast 'post removed', 4000, 'success'
    else if (@status is 'published' and $('#verification') isnt @title)
          Materialize.toast 'title does not match', 4000, 'error'



Template.EditPost.helpers

  blogPost: ->
    if FlowRouter.subsReady()
      Model.BlogPost.current()

  isEmpty: ->
    not (@post or @title)

  labels: -> Collection.Label.find()

  selectedLabel: ->
    Model.BlogPost.current().hasLabel @_id


Template.EditPost.events

  'click .chip.label': ->
    if Model.BlogPost.current().hasLabel @_id
      console.log("exists")

      existingLabels = Collection.BlogPostLabel.find
        labelId: @_id
        blogPostId: Session.get('currentBlogPostId')
      console.log(existingLabels.fetch())

      _.invoke existingLabels.fetch(), 'remove'
    else
      console.log("dunt")
      blogPostLabel = new Model.BlogPostLabel
        labelId: @_id
        blogPostId: Session.get('currentBlogPostId')
      blogPostLabel.save()


Template.RemovePost.helpers

  blogPost: ->
    if FlowRouter.subsReady()
      Model.BlogPost.current()
