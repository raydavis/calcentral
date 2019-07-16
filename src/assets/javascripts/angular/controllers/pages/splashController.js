'use strict';

/**
 * Splash controller
 */
angular.module('calcentral.controllers').controller('SplashController', function(apiService, $filter, $scope) {
  apiService.util.setTitle('Home');
});
