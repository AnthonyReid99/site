@Util = {}


@Util.optional = (validator) ->
  if validator.constructor is Array
    Validators.or validator.concat [Validators.null()]
  else
    Validators.or [
      Validators.null()
      validator
    ]

