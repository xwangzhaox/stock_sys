class Api::V1::SessionController < Api::V1::BaseController
  include Swagger::Blocks

  skip_before_action :authenticate, only: [:create]
  # skip_before_action :verify_authenticity_token, only: [:create]

  swagger_named_path :api_v1_session_index do
    operation :post do
      key :tags, [
                   'Session'
               ]
      key :summary, '登录'
      key :description, '接收email, password，绑定用户信息，自动登陆。'
      key 'x-position', 1
      simple_parameter :email, :string, required: true, description: '用户名'
      simple_parameter :password, :string, required: true, description: '密码'
      response 200
    end
  end
  def create
  	user = User.find_by_email(params[:email])

  	unless user && user.valid_password?(params[:password])
  	  handle_error(code:304, message: "User undefined.") and return
  	end

  	begin
  	  sign_in(user)
      @current_user = user
  	rescue StandardError => e
  	  logger.warn("handle_error: user is invalid.")
      handle_error(code:304, message: "user is invalid.") and return
  	end

    info = {user_id: @current_user.id, exp: (Time.now.to_i + 1.days)}
    @user_token = JWT.encode info, Rails.application.credentials.user_token_secret, "HS256"

    @current_user.update_attribute(:token, @user_token)
    render :json=>{code:0,user_token:@user_token, username: @current_user.username, avatar: @current_user.avatar.service_url}
  end

  swagger_named_path :logout_api_v1_session_index do
    operation :post do
      key :tags, [
                   'Session'
               ]
      key :summary, '登出'
      key :description, '退出登录'
      key 'x-position', 5
      response 200
    end
  end
  def logout
    @current_user.update_attribute(:token, "")
    sign_out
    @current_user = nil
    render :json=>{code:0}
  end
end