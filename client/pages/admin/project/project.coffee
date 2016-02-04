Template.Projects.helpers

  projects: ->
    Collection.Project.find {},
      sort:
        createdAt: -1

  createdAt: ->
    moment(@createdAt).format 'MMM D YYYY @ h:mA'

  author: ->
    user = Meteor.users.findOne @creator
    user?.username or 'unknown'


Template.Projects.events

  'click .create-project': ->
    if not Meteor.userId()

      $('#login-modal').openModal()
      return

    newProject = new Model.Project
      creator: Meteor.userId()
      status: 'draft'
    newProject.save (err, id) ->
      if err
        console.log('error saving project')
      else
        Session.set 'currentProjectId', id
        $('#edit-project.modal').openModal
          ready: =>
            MDEdit.projectDescription?.valueOf().codemirror.getDoc().setValue(newProject.description)

  'click .action-buttons .save': ->
    @set
      description: MDEdit.projectDescription.value()
      name: $('#name').val()
    @save (err, id) ->
      if err
        Materialize.toast 'error saving project', 4000, 'error'
      else
        Materialize.toast 'saved!', 4000

  'click .action-buttons .publish': ->

    @set
      description: MDEdit.projectDescription.value()
      name: $('#name').val()
      status: 'published'
    @save (err, id) ->
      if err
        Materialize.toast 'error saving project', 4000, 'error'
      else
        $('#edit-project.modal').closeModal()
        Materialize.toast 'published!', 4000

  'click .edit-project': (event) ->
    event.stopPropagation()
    Session.set 'currentProjectId', @_id
    Session.set 'projectLoading', true

    $('#edit-project.modal').openModal
      ready: =>
        MDEdit.projectDescription.valueOf().codemirror.getDoc().setValue(@description)
        Session.set 'projectLoading', false

  'click .remove-project': ->
    Session.set 'currentProjectId', @_id
    $('#remove-project.modal').openModal()

  'click .confirm-remove': (event) ->
    if @status is 'draft' or (@status is 'published' and $('#verification').val() is @name)
      @projectLabels().forEach (projectLabel) ->
        projectLabel.remove()
      @remove (err, count) ->
        if not err and count is 1
          $('#remove-project.modal').closeModal()
          Materialize.toast 'project removed', 4000, 'success'
    else if (@status is 'published' and $('#verification') isnt @name)
          Materialize.toast 'title does not match', 4000, 'error'



Template.EditProject.helpers

  project: ->
    if FlowRouter.subsReady()
      Model.Project.current()

  isEmpty: ->
    not (@description or @name)

  labels: -> Collection.Label.find()

  selectedLabel: ->
    Model.Project.current().hasLabel @_id


Template.EditProject.events

  'click .chip.label': ->
    if Model.Project.current().hasLabel @_id
      existingLabels = Collection.ProjectLabel.find
        labelId: @_id
        projectId: Session.get('currentProjectId')
      console.log(existingLabels.fetch())

      _.invoke existingLabels.fetch(), 'remove'
    else
      projectLabel = new Model.ProjectLabel
        labelId: @_id
        projectId: Session.get('currentProjectId')
      projectLabel.save()


Template.RemoveProject.helpers

  project: ->
    if FlowRouter.subsReady()
      Model.Project.current()
