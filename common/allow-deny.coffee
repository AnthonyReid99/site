for _, modelClass of Model
  do (modelClass) ->
    collection = modelClass.getCollection()

    collection.allow
      insert: (userId, doc) =>
        # Inflate and validate
        model = new modelClass doc
        if model.validate()
          true
        else
          console.log 'Validation error in update(). Astronomy validation error: '
          console.log model.getValidationErrors()
          false

      update: (userId, doc, fields, query) ->

        model = new modelClass collection.findOne(doc._id)

        # Make sure this is the correct user
        if doc.creator isnt userId
          console.log "Validation error in update(). User '#{userId}' does not match creator '#{doc.creator}'"
          return false

        # Make sure the update query stays within its lane
        try
          check query,
             $set: Match.Any
        catch error
          console.log 'Validation error in update(). Invalid query: '
          console.log query
          return false

        # Don't allow users to mess with _id or _owner
        if query.$set._id or query.$set._owner
          console.log 'Validation error in update(). Attempting to update _id or _owner'
          return false

        # Apply and validate
        model.set query.$set
        if model.validate()
          true
        else
          console.log 'Validation error in update(). Astronomy validation error: '
          console.log model.getValidationErrors()
          false

      remove: (userId, doc) ->
        whiteList = [
          'Label'
          'BlogPostLabel'
          'ProjectLabel'
        ]

        if modelClass.schema.className in whiteList
          return true

        if doc.creator isnt userId
          console.log "Validation error in remove(). User '#{userId}' does not match creator '#{doc.creator}'"
          return false

        return true
