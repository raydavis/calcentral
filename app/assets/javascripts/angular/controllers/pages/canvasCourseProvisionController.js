(function(calcentral) {
  'use strict';

  /**
   * Canvas course provisioning LTI app controller
   */
  calcentral.controller('CanvasCourseProvisionController', ['apiService', '$http', '$scope', '$timeout', '$window', function (apiService, $http, $scope, $timeout, $window) {

    apiService.util.setTitle('bCourses Course Provision');

    /**
     * Post a message to the parent
     * @param {String|Object} message Message you want to send over.
     */
    var postMessage = function(message) {
      if ($window.parent) {
        $window.parent.postMessage(message, '*');
      }
    };

    var postHeight = function() {
      postMessage({
        height: document.body.scrollHeight
      });
    };

    var statusProcessor = function() {
      if ($scope.status === 'Processing' || $scope.status === 'New') {
        courseSiteJobStatusLoader();
      } else {
        $timeout.cancel(timeout_promise);
      }
    };

    var timeout_promise;
    var courseSiteJobStatusLoader = function() {
      $scope.current_workflow_step = 'monitoring_job';
      timeout_promise = $timeout(function() {
        fetchStatus(statusProcessor);
      }, 2000);
    };

    var clearCourseSiteJob = function() {
      delete $scope.job_id;
      delete $scope.job_request_status;
      delete $scope.status;
      delete $scope.completed_steps;
      delete $scope.percent_complete;
    };

    var courseSiteJobCreated = function(data) {
      angular.extend($scope, data);
      courseSiteJobStatusLoader();
    };

    $scope.createCourseSiteJob = function(selected_courses) {
      var ccns = [];
      angular.forEach(selected_courses, function(course) {
        angular.forEach(course.sections, function(section) {
          if (section.selected) {
            ccns.push(section.ccn);
          }
        });
      });
      if (ccns.length > 0) {
        var new_course = {
          'term_slug': $scope.current_semester,
          'ccns': ccns
        };
        if ($scope.acting_as) {
          new_course.instructor_id = $scope.acting_as;
        }
        $http.post('/api/academics/canvas/course_provision/create', new_course)
          .success(courseSiteJobCreated)
          .error(function() {
            angular.extend($scope, {
              current_workflow_step: 'monitoring_job',
              status: 'Error',
              error: 'Failed to create course provisioning job.'
            });
          });
      }
    };

    var fetchStatus = function(callback) {
      var status_url = '/api/academics/canvas/course_provision/status.json?job_id='+ $scope.job_id;
      $http.get(status_url).success(function(data) {
        angular.extend($scope, data);
        $scope.percent_complete_rounded = Math.round($scope.percent_complete * 100);
        callback();
      });
    };

    $scope.fetchFeed = function() {
      clearCourseSiteJob();
      angular.extend($scope, {
        current_workflow_step: 'selecting',
        _is_loading: true,
        created_status: false
      });
      var feed_url = '';
      if ($scope.acting_as && $scope.is_admin) {
        feed_url = '/api/academics/canvas/course_provision_as/' + $scope.acting_as;
      } else {
        feed_url = '/api/academics/canvas/course_provision';
      }
      $http.get(feed_url).success(function(data) {
        angular.extend($scope, data);
        window.setInterval(postHeight, 250);
        if ($scope.teaching_semesters && $scope.teaching_semesters.length > 0) {
          $scope.switchSemester($scope.teaching_semesters[0]);
        }
      });
    };

    $scope.switchSemester = function(semester) {
      angular.extend($scope, {
        current_semester: semester.slug,
        selected_courses: semester.classes
      });
    };

    $scope.fetchFeed();
  }]);

})(window.calcentral);
