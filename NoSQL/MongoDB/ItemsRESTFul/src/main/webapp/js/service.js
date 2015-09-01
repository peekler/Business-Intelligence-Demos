(function () {
    'use strict';

    angular
        .module('main')
        .factory('RESTService', RESTService);

    function RESTService ($http) {
        function getITems(callback) {
            $http.get("http://localhost:8080/api/items")
                .success(callback);
        };

        return {
            getITems: getITems
        }
    }
})();
