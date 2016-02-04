navItems = []

navItems.push
  text: 'home'
  routeName: 'Home'

navItems.push
  text: 'blog'
  routeName: 'Blog'

navItems.push
  text: 'projects'
  routeName: 'Projects'

navItems.push
  text: 'contact'
  routeName: 'Contact'

navItems.push
  text: 'admin'
  routeName: 'Admin'
  adminOnly: true


Template.MainLayout.onCreated ->
  document.title = "Anthony Reid"


Template.Navbar.helpers

  navItems: ->
    _.filter navItems, (item) -> (not item.adminOnly?) or (item.adminOnly and Meteor.userId())

  isActive: ->
    FlowRouter.watchPathChange()
    FlowRouter.current().route.name is @routeName


Template.Navbar.events

  'click .nav-link': ->
    FlowRouter.go FlowRouter.path @routeName

  'click .login-button': ->
    $('#login-modal').openModal()

  'click a.logout-button': ->
    Meteor.logout()
    if FlowRouter.getRouteName() is 'Admin'
      FlowRouter.go FlowRouter.path('Home')


Template.LoginModal.events

  'submit form.modal-content': (event) ->
    event.stopPropagation()
    event.preventDefault()
    username = $('input#user-name').val()
    password = $('input#password').val()
    Meteor.loginWithPassword username, password, (error) ->
      if error
        $('#login-modal .btn').addClass 'red lighten-2'
      else
        $('form.modal-content').fadeOut ->
          $('.success.modal-content').fadeIn ->
            $('.success.modal-content').fadeOut ->
              $('#login-modal').closeModal()



Template.ColorPicker.onRendered ->
  console.log("rendered")
  console.log($("select[name='color']"))

  $("select[name='color']").simplecolorpicker
    picker: true


Template.ColorPicker.helpers

  'colors': -> [
      {hexValue: '#9bdbb4'}
      {hexValue: '#97dce6'}
      {hexValue: '#b7c1dc'}
      {hexValue: '#e3bbd6'}
      {hexValue: '#f6bebe'}
      {hexValue: '#ffdd81'}
      {hexValue: '#d4d4d4'}
      {hexValue: '#37b669'}
      {hexValue: '#2eb8cc'}
      {hexValue: '#6f83b8'}
      {hexValue: '#c777ad'}
      {hexValue: '#ec7c7c'}
      {hexValue: '#e8b44b'}
      {hexValue: '#a9a8a8'}
      {hexValue: '#2a8c51'}
      {hexValue: '#238d9d'}
      {hexValue: '#55658d'}
      {hexValue: '#995b85'}
      {hexValue: '#b55f5f'}
      {hexValue: '#c2850b'}
      {hexValue: '#828181'}
    ]
