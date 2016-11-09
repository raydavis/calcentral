
Calcentral::Application.routes.draw do

  mount RailsAdmin::Engine => '/ccadmin', :as => 'rails_admin'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'bootstrap#index'

  # User management/status endpoints.
  get '/api/my/am_i_logged_in' => 'user_api#am_i_logged_in', :as => :am_i_logged_in, :defaults => { :format => 'json' }
  get '/api/my/status' => 'user_api#mystatus', :as => :mystatus, :defaults => { :format => 'json' }
  post '/api/my/record_first_login' => 'user_api#record_first_login', :as => :record_first_login, :defaults => { :format => 'json' }, :via => :post
  post '/api/my/calendar/opt_in' => 'user_api#calendar_opt_in', :via => :post
  post '/api/my/calendar/opt_out' => 'user_api#calendar_opt_out', :via => :post

  # Feeds of read-only content
  get '/api/advising/my_advising' => 'my_advising#get_feed', :as => :advising, :defaults => {:format => 'json'}
  get '/api/my/classes' => 'my_classes#get_feed', :as => :my_classes, :defaults => { :format => 'json' }
  get '/api/my/photo' => 'photo#my_photo', :as => :my_photo, :defaults => {:format => 'jpeg' }
  get '/api/photo/:uid' => 'photo#photo', :as => :photo, :defaults => {:format => 'jpeg' }
  get '/api/my/textbooks_details' => 'my_textbooks#get_feed', :as => :my_textbooks, :defaults => { :format => 'json' }
  get '/api/my/up_next' => 'my_up_next#get_feed', :as => :my_up_next, :defaults => { :format => 'json' }
  get '/api/my/tasks' => 'my_tasks#get_feed', :via => :get, :as => :my_tasks, :defaults => { :format => 'json' }
  get '/api/my/groups' => 'my_groups#get_feed', :as => :my_groups, :defaults => { :format => 'json' }
  get '/api/my/activities' => 'my_activities#get_feed', :as => :my_activities, :defaults => { :format => 'json' }
  get '/api/my/badges' => 'my_badges#get_feed', :as => :my_badges, :defaults => { :format => 'json' }
  get '/api/my/academics' => 'my_academics#get_feed', :as => :my_academics, :defaults => { :format => 'json' }
  get '/api/my/class_enrollments' => 'my_class_enrollments#get_feed', :via => :get, :defaults => { :format => 'json' }
  get '/api/my/residency' => 'my_academics#residency', :via => :get, :defaults => { :format => 'json' }
  get '/api/my/eft_enrollment' => 'my_eft_enrollment#get_feed', :as => :my_eft_enrollment, :defaults => { :format => 'json' }
  get '/api/my/financials' => 'my_financials#get_feed', :as => :my_financials, :defaults => {:format => 'json'}
  get '/api/my/finaid' => 'my_finaid#get_feed', :as => :my_finaid, :defaults => {:format => 'json'}
  get '/api/my/cal1card' => 'my_cal1card#get_feed', :as => :my_cal1card, :defaults => {:format => 'json'}
  # TODO This legacy advising endpoint will not remain long.
  get '/api/my/advising' => 'my_advising#get_legacy_feed', :as => :my_advising, :defaults => {:format => 'json'}
  get '/api/my/campuslinks' => 'my_campus_links#get_feed', :as => :my_campus_links, :defaults => { :format => 'json' }
  get '/api/my/campuslinks/expire' => 'my_campus_links#expire'
  get '/api/my/campuslinks/refresh' => 'my_campus_links#refresh', :defaults => { :format => 'json' }
  get '/api/my/registrations' => 'my_registrations#get_feed', :via => :get, :defaults => { :format => 'json' }
  get '/api/my/updated_feeds' => 'is_updated#list', :defaults => {:format => 'json'}
  get '/api/service_alerts' => 'service_alerts#get_feed', :as => :service_alerts, :defaults => { :format => 'json' }
  get '/api/media/:term_yr/:term_cd/:dept_name/:catalog_id' => 'mediacasts#get_media', :defaults => { :format => 'json' }
  get '/api/my/committees' => 'my_committees#get_feed', :defaults => { :format => 'json' }
  get '/api/my/committees/photo/member/:member_id' => 'my_committees#member_photo', :defaults => { :format => 'jpeg' }
  get '/api/my/committees/photo/student/:student_id' => 'my_committees#student_photo', :defaults => { :format => 'jpeg' }

  # Google API writing endpoints
  post '/api/my/event' => 'my_events#create', via: :post, defaults: { format: 'json' }
  post '/api/my/tasks' => 'my_tasks#update_task', :via => :post, :as => :update_task, :defaults => { :format => 'json' }
  post '/api/my/tasks/create' => 'my_tasks#insert_task', :via => :post, :as => :insert_task, :defaults => { :format => 'json' }
  post '/api/my/tasks/clear_completed' => 'my_tasks#clear_completed_tasks', :via => :post, :as => :clear_completed_tasks, :defaults => { :format => 'json' }
  post '/api/my/tasks/delete/:task_id' => 'my_tasks#delete_task', :via => :post, :as => :delete_task, :defaults => { :format => 'json' }

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
  get '/api/academics/rosters/campus/:campus_course_id' => 'campus_rosters#get_feed', :as => :campus_roster, :defaults => { :format => 'json' }
  get '/api/academics/rosters/canvas/csv/:canvas_course_id' => 'canvas_rosters#get_csv', :as => :canvas_roster_csv, :defaults => { :format => 'csv' }
  get '/api/academics/rosters/campus/csv/:campus_course_id' => 'campus_rosters#get_csv', :as => :campus_roster_csv, :defaults => { :format => 'csv' }
  get '/canvas/:canvas_course_id/photo/:person_id' => 'canvas_rosters#photo', :defaults => { :format => 'jpeg' }, :action => 'show'
  get '/canvas/:canvas_course_id/profile/:person_id' => 'canvas_rosters#profile'
  get '/campus/:campus_course_id/photo/:person_id' => 'campus_rosters#photo', :defaults => { :format => 'jpeg' }, :action => 'show'
  get '/api/academics/canvas/course_provision' => 'canvas_course_provision#get_feed', :as => :canvas_course_provision, :defaults => { :format => 'json' }
  get '/api/academics/canvas/course_provision_as/:admin_acting_as' => 'canvas_course_provision#get_feed', :as => :canvas_course_provision_as, :defaults => { :format => 'json' }
  post '/api/academics/canvas/course_provision/create' => 'canvas_course_provision#create_course_site', :via => :post, :as => :canvas_course_create, :defaults => { :format => 'json' }
  get '/api/academics/canvas/course_provision/sections_feed/:canvas_course_id' => 'canvas_course_provision#get_sections_feed', :as => :canvas_course_sections_feed, :defaults => { :format => 'json' }
  post '/api/academics/canvas/course_provision/edit_sections/:canvas_course_id' => 'canvas_course_provision#edit_sections', :via => :post, :as => :canvas_course_edit_sections, :defaults => { :format => 'json' }
  get '/api/academics/canvas/course_provision/status' => 'canvas_course_provision#job_status', :via => :get, :as => :canvas_course_job_status, :defaults => { :format => 'json' }
  post '/api/academics/canvas/project_provision/create' => 'canvas_project_provision#create_project_site', :via => :post, :as => :canvas_project_create, :defaults => { :format => 'json' }
  post '/api/academics/canvas/user_provision/user_import' => 'canvas_user_provision#user_import', :as => :canvas_user_provision_import, :defaults => { :format => 'json' }
  get '/api/academics/canvas/site_creation/authorizations' => 'canvas_site_creation#authorizations', :as => :canvas_site_creation_authorizations, :defaults => { :format => 'json' }
  get '/api/academics/canvas/course_add_user/:canvas_course_id/search_users' => 'canvas_course_add_user#search_users', :via => :get, :as => :canvas_course_add_user_search_users, :defaults => { :format => 'json' }
  get '/api/academics/canvas/course_add_user/:canvas_course_id/course_sections' => 'canvas_course_add_user#course_sections', :via => :get, :as => :canvas_course_add_user_course_sections, :defaults => { :format => 'json' }
  post '/api/academics/canvas/course_add_user/:canvas_course_id/add_user' => 'canvas_course_add_user#add_user', :via => :post, :as => :canvas_course_add_user_add_user, :defaults => { :format => 'json' }
  get '/api/canvas/media/:canvas_course_id' => 'canvas_webcast_recordings#get_media', :defaults => { :format => 'json' }
  # Administer Canvas mailing list for a single course site
  get '/api/academics/canvas/mailing_list/:canvas_course_id' => 'canvas_mailing_list#show', :defaults => { :format => 'json' }
  post '/api/academics/canvas/mailing_list/:canvas_course_id/create' => 'canvas_mailing_list#create', :defaults => { :format => 'json' }
  # Administer Canvas mailing lists for any course site
  get '/api/academics/canvas/mailing_lists/:canvas_course_id' => 'canvas_mailing_lists#show', :defaults => { :format => 'json' }
  post '/api/academics/canvas/mailing_lists/:canvas_course_id/create' => 'canvas_mailing_lists#create', :defaults => { :format => 'json' }
  post '/api/academics/canvas/mailing_lists/:canvas_course_id/populate' => 'canvas_mailing_lists#populate', :defaults => { :format => 'json' }
  post '/api/academics/canvas/mailing_lists/:canvas_course_id/delete' => 'canvas_mailing_lists#destroy', :defaults => { :format => 'json' }

  # OEC endpoints
  get '/api/oec/google/request_authorization'=> 'oec_google_auth#refresh_tokens', :defaults => { :format => 'json' }
  get '/api/oec/google/handle_callback' => 'oec_google_auth#handle_callback', :defaults => { :format => 'json' }
  get '/api/oec/google/current_scope' => 'oec_google_auth#current_scope', :defaults => { :format => 'json' }
  get '/api/oec/google/remove_authorization' => 'oec_google_auth#remove_authorization', :via => :post
  get '/api/oec/tasks' => 'oec_tasks#index', :defaults => { :format => 'json' }
  post '/api/oec/tasks/:task_name' => 'oec_tasks#run', :defaults => { :format => 'json' }
  get '/api/oec/tasks/status/:task_id' => 'oec_tasks#task_status',  :defaults => { :format => 'json' }

  # System utility endpoints
  get '/api/cache/clear' => 'cache#clear', :defaults => { :format => 'json' }
  get '/api/cache/delete' => 'cache#delete', :defaults => { :format => 'json' }
  get '/api/cache/delete/:key' => 'cache#delete', :defaults => { :format => 'json' }
  get '/api/cache/warm/:uid' => 'cache#warm', :defaults => { :format => 'json' }
  get '/api/config' => 'config#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/ping' => 'ping#do', :defaults => {:format => 'json'}
  get '/api/reload_yaml_settings' => 'yaml_settings#reload', :defaults => { :format => 'json' }
  get '/api/server_info' => 'server_runtime#get_info', :via => :get
  get '/api/stats' => 'stats#get_stats', :via => :get, :defaults => { :format => 'json' }
  get '/api/smoke_test_routes' => 'routes_list#smoke_test_routes', :as => :all_routes, :defaults => { :format => 'json' }

  # Oauth endpoints: Google
  get '/api/google/request_authorization'=> 'google_auth#refresh_tokens'
  get '/api/google/handle_callback' => 'google_auth#handle_callback'
  get '/api/google/current_scope' => 'google_auth#current_scope'
  post '/api/google/remove_authorization' => 'google_auth#remove_authorization', :via => :post
  post '/api/google/dismiss_reminder' => 'google_auth#dismiss_reminder', :defaults => { :format => 'json'}, :via => :post

  # Authentication endpoints
  get '/auth/cas/callback' => 'sessions#lookup'
  get '/auth/failure' => 'sessions#failure'
  get '/reauth/admin' => 'sessions#reauth_admin', :as => :reauth_admin
  if Settings.developer_auth.enabled
    # the backdoor for http basic auth (bypasses CAS) only on development environments.
    get '/basic_auth_login' => 'sessions#basic_lookup'
    get '/logout' => 'sessions#destroy', :as => :logout
    post '/logout' => 'sessions#destroy', :as => :logout_post, :via => :post
  else
    post '/logout' => 'sessions#destroy', :as => :logout, :via => :post
  end

  # Search for users
  get '/api/search_users/:id' => 'search_users#by_id', :via => :get, :defaults => { :format => 'json' }
  get '/api/search_users/id_or_name/:input' => 'search_users#by_id_or_name', :defaults => { :format => 'json' }

  # View-as endpoints
  get '/api/view_as/my_stored_users' => 'stored_users#get', :defaults => { :format => 'json' }
  post '/api/view_as/store_user_as_saved' => 'stored_users#store_saved_uid', defaults: { format: 'json' }
  post '/api/view_as/store_user_as_recent' => 'stored_users#store_recent_uid', defaults: { format: 'json' }
  post '/act_as' => 'act_as#start'
  post '/stop_act_as' => 'act_as#stop'
  post '/delete_user/saved' => 'stored_users#delete_saved_uid', via: :post, defaults: { format: 'json' }
  post '/delete_users/recent' => 'stored_users#delete_all_recent', via: :post, defaults: { format: 'json' }
  post '/delete_users/saved' => 'stored_users#delete_all_saved', via: :post, defaults: { format: 'json' }

  # Advisor endpoints
  get '/api/advising/academics/:student_uid' => 'advising_student#academics', :defaults => { :format => 'json' }
  get '/api/advising/class_enrollments/:student_uid' => 'advising_student#enrollment_instructions', :defaults => { :format => 'json'}
  get '/api/advising/academic_status/:student_uid' => 'advising_student#academic_status', :defaults => { :format => 'json' }
  get '/api/advising/registrations/:student_uid' => 'advising_student#registrations', :defaults => { :format => 'json' }
  get '/api/advising/resources/:student_uid' => 'advising_student#resources', :defaults => { :format => 'json' }
  get '/api/advising/student/:student_uid' => 'advising_student#profile', :defaults => { :format => 'json' }
  get '/api/advising/student_attributes/:student_uid' => 'advising_student#student_attributes', :defaults => { :format => 'json' }
  get '/api/advising/advising/:student_uid' => 'advising_student#advising', :defaults => { :format => 'json' }
  get '/api/advising/student_success/:student_uid' => 'advising_student#student_success', :defaults => { :format => 'json' }
  get '/api/advising/degree_progress/grad/:student_uid' => 'advising_student#degree_progress_graduate', :defaults => { :format => 'json' }
  get '/api/advising/degree_progress/ugrd/:student_uid' => 'advising_student#degree_progress_undergrad', :defaults => { :format => 'json' }
  post '/advisor_act_as' => 'advisor_act_as#start'
  post '/stop_advisor_act_as' => 'advisor_act_as#stop'

  # Delegated Access endpoints
  get '/api/campus_solutions/delegate_terms_and_conditions' => 'campus_solutions/delegate_access#get_terms_and_conditions', :defaults => { :format => 'json' }
  get '/api/campus_solutions/delegate_management_url' => 'campus_solutions/delegate_access#get_delegate_management_url', :defaults => { :format => 'json' }
  get '/api/campus_solutions/delegate_access/students' => 'campus_solutions/delegate_access#get_students', :defaults => { :format => 'json' }
  post '/delegate_act_as' => 'delegate_act_as#start'
  post '/stop_delegate_act_as' => 'delegate_act_as#stop'
  post '/api/campus_solutions/delegate_access' => 'campus_solutions/delegate_access#post', :defaults => { :format => 'json' }

  # Campus Solutions general purpose endpoints
  get '/api/campus_solutions/checklist' => 'campus_solutions/checklist#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/sir_config' => 'campus_solutions/sir_config#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/deposit' => 'campus_solutions/deposit#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/higher_one_url' => 'campus_solutions/higher_one_url#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/country' => 'campus_solutions/country#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/state' => 'campus_solutions/state#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/ethnicity_setup' => 'campus_solutions/ethnicity_setup#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/address_label' => 'campus_solutions/address_label#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/address_type' => 'campus_solutions/address_type#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/name_type' => 'campus_solutions/name_type#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/currency_code' => 'campus_solutions/currency_code#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/language_code' => 'campus_solutions/language_code#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/translate' => 'campus_solutions/translate#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/aid_years' => 'campus_solutions/aid_years#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/financial_aid_compare_awards_current' => 'campus_solutions/financial_aid_compare_awards_current#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/financial_aid_compare_awards_list' => 'campus_solutions/financial_aid_compare_awards_list#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/financial_aid_compare_awards_prior' => 'campus_solutions/financial_aid_compare_awards_prior#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/financial_aid_data' => 'campus_solutions/financial_aid_data#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/financial_aid_funding_sources' => 'campus_solutions/financial_aid_funding_sources#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/financial_aid_funding_sources_term' => 'campus_solutions/financial_aid_funding_sources_term#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/holds' => 'campus_solutions/holds#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/enrollment_verification_messages' => 'campus_solutions/enrollment_verification_messages#get', :via => :get, :defaults => {:format => 'json'}
  get '/api/campus_solutions/advising_resources' => 'campus_solutions/advising_resources#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/ferpa_deeplink' => 'campus_solutions/ferpa_deeplink#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/enrollment_verification_deeplink' => 'campus_solutions/enrollment_verification_deeplink#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/billing' => 'campus_solutions/billing#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/slr_deeplink' => 'campus_solutions/slr_deeplink#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/fpp_enrollment' => 'campus_solutions/fpp_enrollment#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/emergency_contacts' => 'campus_solutions/emergency_contacts#get', :via => :get, :defaults => { :format => 'json' }
  get '/api/campus_solutions/link' => 'campus_solutions/link#get', :defaults => { :format => 'json' }
  get '/api/campus_solutions/student_resources' => 'campus_solutions/student_resources#get', :defaults => { :format => 'json' }
  get '/api/campus_solutions/degree_progress' => 'campus_solutions/degree_progress#get', :defaults => { :format => 'json' }
  post '/api/campus_solutions/address' => 'campus_solutions/address#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/email' => 'campus_solutions/email#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/person_name' => 'campus_solutions/person_name#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/phone' => 'campus_solutions/phone#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/emergency_contact' => 'campus_solutions/emergency_contact#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/emergency_phone' => 'campus_solutions/emergency_phone#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/language' => 'campus_solutions/language#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/work_experience' => 'campus_solutions/work_experience#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/ethnicity' => 'campus_solutions/ethnicity#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/terms_and_conditions' => 'campus_solutions/terms_and_conditions#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/title4' => 'campus_solutions/title4#post', :via => :post, :defaults => { :format => 'json' }
  post '/api/campus_solutions/sir_response' => 'campus_solutions/sir_response#post', :via => :post, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/address/:type' => 'campus_solutions/address#delete', :via => :delete, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/email/:type' => 'campus_solutions/email#delete', :via => :delete, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/emergency_contact/:contactName' => 'campus_solutions/emergency_contact#delete', :via => :delete, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/emergency_phone/:contactName/:phoneType' => 'campus_solutions/emergency_phone#delete', :via => :delete, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/language/:languageCode' => 'campus_solutions/language#delete', :via => :delete, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/person_name/:type' => 'campus_solutions/person_name#delete', :via => :delete, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/phone/:type' => 'campus_solutions/phone#delete', :via => :delete, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/ethnicity/:ethnicGroupCode/:regRegion' => 'campus_solutions/ethnicity#delete', :via => :delete, :defaults => { :format => 'json' }
  delete '/api/campus_solutions/work_experience/:sequenceNbr' => 'campus_solutions/work_experience#delete', :via => :delete, :defaults => { :format => 'json' }

  # Redirect to College Scheduler
  get '/college_scheduler/:acad_career/:term_id' => 'campus_solutions/college_scheduler#get'

  # Redirect to HigherOne
  get '/higher_one/higher_one_url' => 'campus_solutions/higher_one_url#redirect'

  # Redirect to National Student ClearingHouse
  get '/clearing_house/clearing_house_url' => 'my_clearing_house_url#redirect'

  # EDOs from integration hub
  get '/api/edos/academic_status' => 'hub_edo#academic_status', :via => :get, :defaults => { :format => 'json' }
  get '/api/edos/student' => 'hub_edo#student', :via => :get, :defaults => { :format => 'json' }
  get '/api/edos/student_attributes' => 'hub_edo#student_attributes', :via => :get, :defaults => { :format => 'json' }
  get '/api/edos/work_experience' => 'hub_edo#work_experience', :via => :get, :defaults => { :format => 'json' }

  # Incoming email messages
  post '/api/mailing_lists/message' => 'mailing_lists_message#relay', :defaults => { :format => 'json' }

  # All the other paths should use the bootstrap page
  # We need this because we use html5mode=true
  #
  # This should ALWAYS be the last rule on the routes list!
  get '/*url' => 'bootstrap#index', :defaults => { :format => 'html' }
end
