class DashboardController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:upload_custom_img_for_web_display]
  skip_before_action :verify_authenticity_token, only: [:upload_custom_img_for_web_display]

  def index
  end
end
