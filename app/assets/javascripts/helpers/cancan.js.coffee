# Public: CoffeeScript CanCan implementation that is dynamically mirrored from
# rails.
Showgap.Helpers.CanCan =
  # Public: Check if the user can do a given action on a given subject.
  # Delegates to internal _can method.
  #
  # Returns the block if the user can do this action.
  can: (action, subject, options) ->
    if Showgap.Helpers.CanCan._can(action, subject)
      options.fn(this)
    else
      options.inverse(this)

  # Public: Inverse of the can method.
  #
  # Returns the block if the user cannot do this action.
  cannot: (action, subject, options) ->
    if Showgap.Helpers.CanCan._cannot(action, subject)
      options.fn(this)
    else
      return options.inverse(this)

  # -------------------
  # Internal Methods
  # -------------------

  # Internal: Get the value of the role string from the current user.
  _currentRole: -> Showgap.User.currentUser.get('role')

  # Internal: Generated by Rails, contains the mapping of roles to subjects to
  # their array of allowed actions.
  #  role1:
  #    subject1: ['edit', 'create']
  #    subject2: ['edit', 'create']
  #  role2:
  #    subject1: ['edit', 'create']
  #    subject2: ['edit', 'create']
  _rulesForRoles: {}

  # Public: Sets the rules hash to a new set of rules.
  setRules: (newRoles) -> @_rulesForRoles = _.clone(newRoles)

  # Internal: The set of rules for the current user's role.
  _rulesForCurrentRole: -> @_rulesForRoles[@_currentRole()]

  # Internal: Checks if the action is allowed for the subject for the role
  # of the current user.
  #
  # action  - Action to check for against subject [manage, edit, read, create,
  #           etc.]
  # subject - Lowercase, singular name of Rails ActiveRecord Model to check.
  #
  # Returns true if action is allowed on subject, false if not.
  _can: (action, subject) ->
    rules = @_rulesForCurrentRole()

    # We don't have rules for this role (or the user isn't logged in),
    # everything is denied.
    return false unless rules

    actions = []
    # Grab the all actions so they can be checked also.
    if 'all' of rules
      actions.add rules['all']

    # Add subject specific rules.
    if subject of rules
      actions.add rules[subject]

    if _.include(actions, 'manage') or _.include(actions, action)
      true
    else
      # Nothing matched, disallow this action subject combo.
      if Showgap.env == 'development'
        console.debug "Denied access #{action} #{subject} for #{@_currentRole()}"
      false

  # Internal: The inverste of _can.
  #
  # Returns the true if the current user cannot do this action on the subject.
  _cannot: (action, subject) -> !@_can(action, subject)