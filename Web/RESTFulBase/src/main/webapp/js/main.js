(function () {
    'use strict';

    angular
        .module('main',[])
        .controller('MainController', MainController);

    function MainController ($scope, RESTService) {
        var vm = this;

        $scope.demoResult = {
            data : "-"
        };

        $scope.demo = demo;

        function demo() {
            RESTService.demoHTTPGet(function(response) {
                $scope.demoResult.data=response;
            })
        }
    }
})();
