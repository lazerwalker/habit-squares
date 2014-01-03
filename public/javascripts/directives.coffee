# Directives

angular.module('habits.directives', []).
  directive 'appVersion', ['version', (version) ->
    return (scope, elm, attrs) ->
      elm.text(version)
  ]