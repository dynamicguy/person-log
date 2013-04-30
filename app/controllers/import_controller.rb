class ImportController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check

  def index

  end

  def linkedin
    if User.not_in?(current_user, 'linkedin')
      redirect_to authentications_path, alert: t("alerts.no_social", :kind => 'LinkedIn')
    else
      QC.enqueue "LinkedinFactory.import_friends", current_user.id
      redirect_to friends_path, notice: "Import process has been started."
    end
  end

  def facebook
    if User.not_in?(current_user, 'facebook')
      redirect_to authentications_path, alert: t("alerts.no_social", :kind => 'facebook')
    else
      QC.enqueue "FacebookFactory.import_friends", current_user.id
      redirect_to friends_path, notice: "Import process has been started."
    end
  end

  def twitter
  end

  def github
    @profile = FacebookFactory.update_profile(current_user)
  end

  def google
    @connections=LinkedinFactory.get_connections(current_user)
  end

  def linkedin_profile
    @profile = LinkedinFactory.update_profile(current_user)
  end
end
