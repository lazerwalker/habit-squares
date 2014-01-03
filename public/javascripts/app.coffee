# Declare app level module which depends on filters, and services
angular.module('habits', [
  'ngRoute',
  'habits.filters',
  'habits.services',
  'habits.directives',
  'habits.controllers'
]).
config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/', {templateUrl: 'partials/squares.html', controller: 'Dashboard'})
]
