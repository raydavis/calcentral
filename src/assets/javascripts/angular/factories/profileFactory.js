'use strict';

/**
 * Profile Factory
 */
angular.module('calcentral.factories').factory('profileFactory', function(apiService) {
  var urlPerson = '/api/my/profile';

  var getPerson = function(options) {
    return apiService.http.request(options, urlPerson);
  };

  return {
    getPerson: getPerson
  };
});
