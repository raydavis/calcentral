'use strict';

/**
 * Admin Factory
 */
angular.module('calcentral.factories').factory('adminFactory', function(apiService, $http) {
  var actAsUrl = '/act_as';
  var userByAnyIdUrl = '/api/search_users/';
  var searchUsersURL = '/api/search_users/id_or_name/';
  var stopActAsUrl = '/stop_act_as';
  var storedUsersUrl = '/api/view_as/my_stored_users';
  var storeSavedUserUrl = '/api/view_as/store_user_as_saved';
  var storeRecentUserUrl = '/api/view_as/store_user_as_recent';
  var deleteSavedUserUrl = '/delete_user/saved';
  var deleteAllRecentUsersUrl = '/delete_users/recent';
  var deleteAllSavedUsersUrl = '/delete_users/saved';

  var actAs = function(user) {
    return $http.post(actAsUrl, user);
  };

  var stopActAs = function() {
    return $http.post(stopActAsUrl);
  };

  var userLookup = function(options) {
    return apiService.http.request(options, userByAnyIdUrl + options.id);
  };

  var searchUsers = function(input) {
    var encodedInput = apiService.http.encode(input);
    return $http.get(searchUsersURL + encodedInput + '/');
  };

  var getStoredUsers = function(options) {
    return apiService.http.request(options, storedUsersUrl);
  };

  var storeUser = function(options) {
    return $http.post(storeSavedUserUrl, options);
  };

  var storeUserAsRecent = function(options) {
    return $http.post(storeRecentUserUrl, options);
  };

  var deleteUser = function(options) {
    return $http.post(deleteSavedUserUrl, options);
  };

  var deleteAllRecentUsers = function() {
    return $http.post(deleteAllRecentUsersUrl);
  };

  var deleteAllSavedUsers = function() {
    return $http.post(deleteAllSavedUsersUrl);
  };

  return {
    actAs: actAs,
    deleteAllRecentUsers: deleteAllRecentUsers,
    deleteAllSavedUsers: deleteAllSavedUsers,
    deleteUser: deleteUser,
    getStoredUsers: getStoredUsers,
    stopActAs: stopActAs,
    storeUser: storeUser,
    storeUserAsRecent: storeUserAsRecent,
    userLookup: userLookup,
    searchUsers: searchUsers
  };
});
