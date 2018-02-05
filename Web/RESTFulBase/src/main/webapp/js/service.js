(function () {
    'use strict';

    angular
        .module('main')
        .factory('RESTService', RESTService);

    function RESTService ($http) {
        function demoHTTPGet(callback) {
            $http.get("http://localhost:8080/api/test")
                .success(callback);
        };

        return {
            demoHTTPGet: demoHTTPGet
        }
    }
})();
