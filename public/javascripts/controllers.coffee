angular.module('habits.controllers', []).
  controller 'Dashboard', ($scope, $http) ->
    fetchData = ->
      $http.get("data.json").
        success (data, status, headers, config) ->
          $scope.habits = data
          $scope.lastUpdated = new Date()
        .error () ->

    fetchDataTimer = ->
      fetchData()
      setTimeout fetchDataTimer, 60000

    $scope.toggle = (service) ->
      return unless $scope.habits[service].tappable
      $scope.habits[service].green = !$scope.habits[service].green
      $http.get("toggle/#{service}?_method=put").
        success (data, status, headers, config) ->
          $scope.habits[service] = data
        .error () ->

    fetchDataTimer()