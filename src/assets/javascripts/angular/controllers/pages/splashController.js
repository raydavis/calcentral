'use strict';

/**
 * Splash controller
 */
angular.module('calcentral.controllers').controller('SplashController', function(apiService) {
  apiService.util.setTitle('Home');
});
