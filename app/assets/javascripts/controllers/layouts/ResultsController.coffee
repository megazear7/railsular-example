controllers = angular.module('controllers')
controllers.controller("ResultsController", [ '$scope', '$routeParams', '$location', '$resource', 'Project', 'Simulation', 'Geometry', 'Result'
  ($scope,$routeParams,$location,$resource,Project,Simulation,Geometry,Result)->
    $scope.link = (url) -> $location.path("/#{url}")

    $scope.projects = Project.all()
    $scope.activeProject = $scope.projects[$routeParams.project_id]
    $scope.results = Result.all()

    if $routeParams.result_id and !isNaN($routeParams.result_id)
      $scope.result = Result.find($routeParams.result_id)
      $scope.showResult = true
    else
      $scope.showResult = false
])
