(function () {
    'use strict';

    angular
        .module('main',[])
        .controller('MainController', MainController);

    function MainController ($scope, RESTService) {
        var vm = this;

        $scope.voteValue = "A";

        $scope.demoResult = {
            data : "-"
        };

        $scope.demo = demo;
        $scope.vote = vote;

        function demo() {
            RESTService.demoHTTPGet(function(response) {
                $scope.demoResult.data=response;
            })
        }

        function vote(vote) {
            RESTService.voteHTTPPost(function(response) {
                $scope.demoResult.data=response;
            }, $scope.voteValue)
        }
    }
})();
