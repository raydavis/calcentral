# RailsAdmin config file.
# See github.com/sferik/rails_admin for more information.

# simple adapter class from our AuthenticationStatePolicy (which is pundit-based) to CanCan, which is greatly preferred by rails_admin.
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :access, :all
      can :dashboard, :all
      if user.policy.can_administrate?
        can :manage, [
          MailingLists::Member,
          MailingLists::SiteMailingList,
          Oec::CourseCode,
          User::Auth
        ]
      end
    end
  end
end

RailsAdmin.config do |config|

  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['CalCentral', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # We're not using Devise or Warden for RailsAdmin authentication; check for superuser in authorize_with instead.
  config.authenticate_with {
    if cookies[:reauthenticated] || !!Settings.features.reauthentication == false
      policy = AuthenticationState.new(session).policy
      redirect_to main_app.root_path unless policy.can_author?
    else
      redirect_to main_app.reauth_admin_path
    end
  }

  # Because CanCan is not inheriting current_user from ApplicationController, we redefine it.
  config.current_user_method {
    AuthenticationState.new(session)
  }

  config.authorize_with :cancan

  # If you want to track changes on your models:
  # config.audit_with :history, 'Adminuser'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  config.default_items_per_page = 50

  # Exclude specific models (keep the others):
  # config.excluded_models = ['OracleDatabase']

  # Include specific models (exclude the others):
  config.included_models = %w(
    MailingLists::Member MailingLists::SiteMailingList
    Oec::CourseCode
    User::Auth
  )

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]

  # config.model This::That do
  # end

  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.
  #

  config.model 'User::Auth' do
    label 'User Authorizations'
    list do
      field :uid do
        column_width 60
      end
      field :is_superuser do
        column_width 20
      end
      field :is_author do
        column_width 20
      end
      field :is_viewer do
        column_width 20
      end
      field :active do
        column_width 20
      end
      field :created_at do
        column_width 130
      end
      field :updated_at do
        column_width 130
      end
    end
  end

  config.model 'MailingLists::Member' do
    label 'Mailing List Memberships'
  end

  config.model 'MailingLists::SiteMailingList' do
    label 'Mailing Lists'
  end

  config.navigation_static_label = 'Tools'

  config.navigation_static_links = {
  }

end
