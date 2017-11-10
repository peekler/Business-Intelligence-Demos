(function () {
    'use strict';

    angular
        .module('main',[])
        .controller('MainController', MainController);

    function MainController ($scope, RESTService) {
        var vm = this;

        $scope.itemsResult = {
            data : "-"
        };

        $scope.getItems = getItems;

        function getItems() {
            RESTService.getITems(function(response) {
                $scope.itemsResult.data=response;
            })
        }
    }
})();
