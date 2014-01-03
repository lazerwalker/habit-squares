# Filters

angular.module('habits.filters', []).
  filter 'interpolate', ['version', (version) ->
    return (text) ->
      return String(text).replace(/\%VERSION\%/mg, version)
  ]