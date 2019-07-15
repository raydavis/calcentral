module ViewAsAuthorization

  def render_403(error)
    if error.respond_to? :message
      render json: { :error => error.message }.to_json, :status => 403
    else
      render :nothing => true, :status => 403
    end
  end

  def authorize_query_stored_users(current_user)
    return if current_user.directly_authenticated? && current_user.policy.can_view_as?
    raise Pundit::NotAuthorizedError.new("User (UID: #{uid}) is not authorized to View As")
  end
end
