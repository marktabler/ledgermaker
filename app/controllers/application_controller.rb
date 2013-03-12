class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    User.find_or_create_by_uid(uid: "TEST", display_name: "TESTER", email: "foo@bar.com")
  end

  def ensure_current_user
    unless current_user
      redirect_to root_path
    end
  end
end
