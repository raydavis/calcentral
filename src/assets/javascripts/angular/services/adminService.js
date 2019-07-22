'use strict';

angular.module('calcentral.services').service('adminService', function(adminFactory, apiService) {
  var actAs = function(user) {
    return adminFactory.actAs({
      uid: getLdapUid(user)
    }).then(apiService.util.redirectToHome);
  };

  var getLdapUid = function(user) {
    return user && (user.ldap_uid || user.ldapUid || user.campusUid);
  };

  return {
    actAs: actAs,
    getLdapUid: getLdapUid
  };
});
