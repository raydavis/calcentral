Calcentral::Application.routes.draw do

  mount RailsAdmin::Engine => '/ccadmin', :as => 'rails_admin'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'bootstrap#index'

  # User management/status endpoints, currently used by all services.
  get '/api/my/am_i_logged_in' => 'user#am_i_logged_in', :as => :am_i_logged_in, :defaults => { :format => 'json' }
  get '/api/my/status' => 'user#my_status', :defaults => { :format => 'json' }
  post '/api/my/record_first_login' => 'user#record_first_login', :as => :record_first_login, :defaults => { :format => 'json' }

  # System utility endpoints
  get '/api/cache/clear' => 'cache#clear', :defaults => { :format => 'json' }
  get '/api/cache/delete' => 'cache#delete', :defaults => { :format => 'json' }
  get '/api/cache/delete/:key' => 'cache#delete', :defaults => { :format => 'json' }
  get '/api/config' => 'config#get', :defaults => { :format => 'json' }
  get '/api/ping' => 'ping#do', :defaults => {:format => 'json'}
  get '/api/server_info' => 'server_runtime#get_info'
  get '/api/smoke_test_routes' => 'routes_list#smoke_test_routes', :as => :all_routes, :defaults => { :format => 'json' }

  # Oauth endpoints: Google
  get '/api/google/request_authorization'=> 'google_auth#refresh_tokens'
  get '/api/google/handle_callback' => 'google_auth#handle_callback'
  get '/api/google/current_scope' => 'google_auth#current_scope'
  post '/api/google/remove_authorization' => 'google_auth#remove_authorization'
  post '/api/google/dismiss_reminder' => 'google_auth#dismiss_reminder', :defaults => { :format => 'json'}

  # Authentication endpoints
  get '/auth/cas/callback' => 'sessions#lookup'
  get '/auth/failure' => 'sessions#failure'
  get '/reauth/admin' => 'sessions#reauth_admin', :as => :reauth_admin
  delete '/logout' => 'sessions#destroy', :as => :logout_ccadmin
  if Settings.developer_auth.enabled
    # the backdoor for http basic auth (bypasses CAS) only on development environments.
    get '/basic_auth_login' => 'sessions#basic_lookup'
    get '/logout' => 'sessions#destroy', :as => :logout
    post '/logout' => 'sessions#destroy', :as => :logout_post
  else
    post '/logout' => 'sessions#destroy', :as => :logout
  end

  # Search for users
  get '/api/search_users/:id' => 'search_users#by_id', :defaults => { :format => 'json' }

  # View-as endpoints
  get '/api/view_as/my_stored_users' => 'stored_users#get', :defaults => { :format => 'json' }
  post '/api/view_as/store_user_as_saved' => 'stored_users#store_saved_uid', defaults: { format: 'json' }
  post '/api/view_as/store_user_as_recent' => 'stored_users#store_recent_uid', defaults: { format: 'json' }
  post '/act_as' => 'act_as#start'
  post '/stop_act_as' => 'act_as#stop'
  post '/delete_user/saved' => 'stored_users#delete_saved_uid', defaults: { format: 'json' }
  post '/delete_users/recent' => 'stored_users#delete_all_recent', defaults: { format: 'json' }
  post '/delete_users/saved' => 'stored_users#delete_all_saved', defaults: { format: 'json' }

  if ProvidedServices.calcentral?
  end

  if ProvidedServices.bcourses?
    # Canvas embedded application support.
    post '/canvas/embedded/*url' => 'canvas_lti#embedded', :defaults => { :format => 'html' }
    get '/canvas/lti_roster_photos' => 'canvas_lti#lti_roster_photos', :defaults => { :format => 'xml' }
    get '/canvas/lti_site_creation' => 'canvas_lti#lti_site_creation', :defaults => { :format => 'xml' }
    get '/canvas/lti_site_mailing_list' => 'canvas_lti#lti_site_mailing_list', :defaults => { :format => 'xml' }
    get '/canvas/lti_site_mailing_lists' => 'canvas_lti#lti_site_mailing_lists', :defaults => { :format => 'xml' }
    get '/canvas/lti_user_provision' => 'canvas_lti#lti_user_provision', :defaults => { :format => 'xml' }
    get '/canvas/lti_course_add_user' => 'canvas_lti#lti_course_add_user', :defaults => { :format => 'xml' }
    get '/canvas/lti_course_mediacasts' => 'canvas_lti#lti_course_mediacasts', :defaults => { :format => 'xml' }
    get '/canvas/lti_course_grade_export' => 'canvas_lti#lti_course_grade_export', :defaults => { :format => 'xml' }
    get '/canvas/lti_course_manage_official_sections' => 'canvas_lti#lti_course_manage_official_sections', :defaults => { :format => 'xml' }
    # A Canvas course ID of "embedded" means to retrieve from session properties.
    get '/api/academics/canvas/course_user_roles/:canvas_course_id' => 'canvas_course_add_user#course_user_roles', :defaults => { :format => 'json' }
    get '/api/academics/canvas/external_tools' => 'canvas#external_tools', :defaults => { :format => 'json' }
    get '/api/academics/canvas/user_can_create_site' => 'canvas#user_can_create_site', :defaults => { :format => 'json' }
    get '/api/academics/canvas/egrade_export/download/:canvas_course_id' => 'canvas_course_grade_export#download_egrades_csv', :defaults => { :format => 'csv' }
    get '/api/academics/canvas/egrade_export/options/:canvas_course_id' => 'canvas_course_grade_export#export_options', :defaults => { :format => 'json' }
    get '/api/academics/canvas/egrade_export/is_official_course' => 'canvas_course_grade_export#is_official_course', :defaults => { :format => 'json' }
    get '/api/academics/canvas/egrade_export/status/:canvas_course_id' => 'canvas_course_grade_export#job_status', :defaults => { :format => 'json' }
    post '/api/academics/canvas/egrade_export/prepare/:canvas_course_id' => 'canvas_course_grade_export#prepare_grades_cache', :defaults => { :format => 'json' }
    post '/api/academics/canvas/egrade_export/resolve/:canvas_course_id' => 'canvas_course_grade_export#resolve_issues', :defaults => { :format => 'json' }
    get '/api/academics/rosters/canvas/:canvas_course_id' => 'canvas_rosters#get_feed', :as => :canvas_roster, :defaults => { :format => 'json' }
    get '/api/academics/rosters/canvas/csv/:canvas_course_id' => 'canvas_rosters#get_csv', :as => :canvas_roster_csv, :defaults => { :format => 'csv' }
    get '/canvas/:canvas_course_id/photo/:person_id' => 'canvas_rosters#photo', :defaults => { :format => 'jpeg' }, :action => 'show'
    get '/canvas/:canvas_course_id/profile/:person_id' => 'canvas_rosters#profile'
    get '/api/academics/canvas/course_provision' => 'canvas_course_provision#get_feed', :as => :canvas_course_provision, :defaults => { :format => 'json' }
    get '/api/academics/canvas/course_provision_as/:admin_acting_as' => 'canvas_course_provision#get_feed', :as => :canvas_course_provision_as, :defaults => { :format => 'json' }
    post '/api/academics/canvas/course_provision/create' => 'canvas_course_provision#create_course_site', :as => :canvas_course_create, :defaults => { :format => 'json' }
    get '/api/academics/canvas/course_provision/sections_feed/:canvas_course_id' => 'canvas_course_provision#get_sections_feed', :as => :canvas_course_sections_feed, :defaults => { :format => 'json' }
    post '/api/academics/canvas/course_provision/edit_sections/:canvas_course_id' => 'canvas_course_provision#edit_sections', :as => :canvas_course_edit_sections, :defaults => { :format => 'json' }
    get '/api/academics/canvas/course_provision/status' => 'canvas_course_provision#job_status', :as => :canvas_course_job_status, :defaults => { :format => 'json' }
    post '/api/academics/canvas/project_provision/create' => 'canvas_project_provision#create_project_site', :as => :canvas_project_create, :defaults => { :format => 'json' }
    post '/api/academics/canvas/user_provision/user_import' => 'canvas_user_provision#user_import', :as => :canvas_user_provision_import, :defaults => { :format => 'json' }
    get '/api/academics/canvas/site_creation/authorizations' => 'canvas_site_creation#authorizations', :as => :canvas_site_creation_authorizations, :defaults => { :format => 'json' }
    get '/api/academics/canvas/course_add_user/:canvas_course_id/search_users' => 'canvas_course_add_user#search_users', :as => :canvas_course_add_user_search_users, :defaults => { :format => 'json' }
    get '/api/academics/canvas/course_add_user/:canvas_course_id/course_sections' => 'canvas_course_add_user#course_sections', :as => :canvas_course_add_user_course_sections, :defaults => { :format => 'json' }
    post '/api/academics/canvas/course_add_user/:canvas_course_id/add_user' => 'canvas_course_add_user#add_user', :as => :canvas_course_add_user_add_user, :defaults => { :format => 'json' }
    get '/api/canvas/media/:canvas_course_id' => 'canvas_webcast_recordings#get_media', :defaults => { :format => 'json' }
    # Administer Canvas mailing list for a single course site
    get '/api/academics/canvas/mailing_list/:canvas_course_id' => 'canvas_mailing_list#show', :defaults => { :format => 'json' }
    post '/api/academics/canvas/mailing_list/:canvas_course_id/create' => 'canvas_mailing_list#create', :defaults => { :format => 'json' }
    # Administer Canvas mailing lists for any course site
    get '/api/academics/canvas/mailing_lists/:canvas_course_id' => 'canvas_mailing_lists#show', :defaults => { :format => 'json' }
    post '/api/academics/canvas/mailing_lists/:canvas_course_id/create' => 'canvas_mailing_lists#create', :defaults => { :format => 'json' }
    post '/api/academics/canvas/mailing_lists/:canvas_course_id/populate' => 'canvas_mailing_lists#populate', :defaults => { :format => 'json' }
    post '/api/academics/canvas/mailing_lists/:canvas_course_id/delete' => 'canvas_mailing_lists#destroy', :defaults => { :format => 'json' }
    # Incoming email messages
    post '/api/mailing_lists/message' => 'mailing_lists_message#relay', :defaults => { :format => 'json' }
  end

  if ProvidedServices.oec?
    # OEC endpoints
    get '/api/oec/google/request_authorization'=> 'oec_google_auth#refresh_tokens', :defaults => { :format => 'json' }
    get '/api/oec/google/handle_callback' => 'oec_google_auth#handle_callback', :defaults => { :format => 'json' }
    get '/api/oec/google/current_scope' => 'oec_google_auth#current_scope', :defaults => { :format => 'json' }
    get '/api/oec/google/remove_authorization' => 'oec_google_auth#remove_authorization'
    get '/api/oec/tasks' => 'oec_tasks#index', :defaults => { :format => 'json' }
    post '/api/oec/tasks/:task_name' => 'oec_tasks#run', :defaults => { :format => 'json' }
    get '/api/oec/tasks/status/:task_id' => 'oec_tasks#task_status',  :defaults => { :format => 'json' }
  end

  # All the other paths should use the bootstrap page
  # We need this because we use html5mode=true
  #
  # This should ALWAYS be the last rule on the routes list!
  get '/*url' => 'bootstrap#index', :defaults => { :format => 'html' }
end
