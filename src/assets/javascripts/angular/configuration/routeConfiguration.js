'use strict';

/**
 * Configure the routes for CalCentral
 */
angular.module('calcentral.config').config(function($routeProvider, calcentralConfig) {
  var providedServices = calcentralConfig.providedServices;

  // List all the routes
  if (providedServices.indexOf('calcentral') === -1) {
    $routeProvider.when('/', {
      templateUrl: 'splash_junction.html',
      controller: 'SplashController',
      isPublic: true
    }).when('/toolbox', {
      templateUrl: 'toolbox_junction.html',
      controller: 'MyToolboxController'
    });
  }

  if (providedServices.indexOf('bcourses') !== -1) {
    $routeProvider.when('/canvas/embedded/rosters', {
      templateUrl: 'canvas_embedded/roster.html',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/site_creation', {
      templateUrl: 'canvas_embedded/site_creation.html',
      controller: 'CanvasSiteCreationController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/site_mailing_list', {
      templateUrl: 'canvas_embedded/site_mailing_list.html',
      controller: 'CanvasSiteMailingListController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/site_mailing_lists', {
      templateUrl: 'canvas_embedded/site_mailing_lists.html',
      controller: 'CanvasSiteMailingListsController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/create_course_site', {
      templateUrl: 'canvas_embedded/create_course_site.html',
      controller: 'CanvasCreateCourseSiteController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/create_project_site', {
      templateUrl: 'canvas_embedded/create_project_site.html',
      controller: 'CanvasCreateProjectSiteController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/user_provision', {
      templateUrl: 'canvas_embedded/user_provision.html',
      controller: 'CanvasUserProvisionController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/course_add_user', {
      templateUrl: 'canvas_embedded/course_add_user.html',
      controller: 'CanvasCourseAddUserController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/course_mediacasts', {
      templateUrl: 'canvas_embedded/course_mediacasts.html',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/course_manage_official_sections', {
      templateUrl: 'canvas_embedded/course_manage_official_sections.html',
      controller: 'CanvasCourseManageOfficialSectionsController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/embedded/course_grade_export', {
      templateUrl: 'canvas_embedded/course_grade_export.html',
      controller: 'CanvasCourseGradeExportController',
      isBcourses: true,
      isEmbedded: true
    }).when('/canvas/rosters/:canvasCourseId', {
      templateUrl: 'canvas_embedded/roster.html',
      isBcourses: true
    }).when('/canvas/site_creation', {
      templateUrl: 'canvas_embedded/site_creation.html',
      controller: 'CanvasSiteCreationController',
      isBcourses: true
    }).when('/canvas/create_course_site', {
      templateUrl: 'canvas_embedded/create_course_site.html',
      controller: 'CanvasCreateCourseSiteController',
      isBcourses: true
    }).when('/canvas/create_project_site', {
      templateUrl: 'canvas_embedded/create_project_site.html',
      controller: 'CanvasCreateProjectSiteController',
      isBcourses: true
    }).when('/canvas/course_manage_official_sections/:canvasCourseId', {
      templateUrl: 'canvas_embedded/course_manage_official_sections.html',
      controller: 'CanvasCourseManageOfficialSectionsController',
      isBcourses: true
    }).when('/canvas/course_grade_export/:canvasCourseId', {
      templateUrl: 'canvas_embedded/course_grade_export.html',
      controller: 'CanvasCourseGradeExportController',
      isBcourses: true
    }).when('/canvas/site_mailing_list/:canvasCourseId', {
      templateUrl: 'canvas_embedded/site_mailing_list.html',
      controller: 'CanvasSiteMailingListController',
      isBcourses: true
    }).when('/canvas/site_mailing_lists', {
      templateUrl: 'canvas_embedded/site_mailing_lists.html',
      controller: 'CanvasSiteMailingListsController',
      isBcourses: true
    }).when('/canvas/user_provision', {
      templateUrl: 'canvas_embedded/user_provision.html',
      controller: 'CanvasUserProvisionController',
      isBcourses: true
    }).when('/canvas/course_add_user/:canvasCourseId', {
      templateUrl: 'canvas_embedded/course_add_user.html',
      controller: 'CanvasCourseAddUserController',
      isBcourses: true
    }).when('/canvas/course_mediacasts/:canvasCourseId', {
      templateUrl: 'canvas_embedded/course_mediacasts.html',
      isBcourses: true
    });
  }

  if (providedServices.indexOf('oec') !== -1) {
    $routeProvider.when('/oec', {
      templateUrl: 'oec.html',
      controller: 'OecController'
    });
  }

  // Redirect to a 404 page
  $routeProvider.otherwise({
    templateUrl: '404.html',
    controller: 'ErrorController',
    isPublic: true
  });
});
