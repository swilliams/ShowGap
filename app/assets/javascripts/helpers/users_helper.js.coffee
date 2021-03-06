# Public: Helpers for showing User view.
Showgap.Helpers.Users =
  # Public: Creates the html based on the user/mini template for a given user
  # and optional text.
  #
  # user    - User attirbutes from a Showgap.User.Model.
  # options - The object of options used to refine the appearance.  This is
  #           automatically generated by Hanldebars when calling
  #           miniUser(option1='option string') (optional).
  #           textBefore - String of text to be shown before the user.
  #           textAfter  - String of text to be shown before the user.
  #           subtle     - Boolean value that determines if the subtle class
  #                        should be applied to this user-mini template
  #                        (default: true).
  #
  # Returns the Handlebars.SafeString of the users/mini generated template.
  miniUser: (user, options) ->
    defaults = {
      textBefore: false
      textAfter: false
      date: ''
      subtle: true
    }

    hash = _.extend(defaults, options.hash)

    template = JST['users/mini']
    new Handlebars.SafeString template(
      user: user
      textBefore: hash.textBefore
      textAfter: hash.textAfter
      isSubtle: hash.subtle
    )
