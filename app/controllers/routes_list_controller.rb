class RoutesListController < ApplicationController
  extend Cache::Cacheable
  include ProvidedServices

  respond_to :json

  def smoke_test_routes
    authorize(current_user, :can_administrate?)
    respond_with({routes: get_smoke_test_routes})
  end

  private

  def get_smoke_test_routes
    routes = %w(
      /api/my/am_i_logged_in
      /api/my/status
      /api/ping
      /api/server_info
    )
    if calcentral?
    end
    if bcourses?
      routes.concat %w(
        /api/academics/canvas/external_tools
        /api/academics/canvas/user_can_create_site
      )
    end
    routes
  end
end
