module ApiBaseSharings
  extend ActiveSupport::Concern

  included do
    include Swagger::Blocks
    include SwaggerNamedPath
    include ActionView::Layouts
    skip_before_action :verify_authenticity_token

    before_action :authenticate
  end

  module ClassMethods
    def api_doc_description
      '<br>' \
      '<br>除 Authentication 和 Lookup 外，其余 API 都需要 user token 才能访问。' \
      '<br>user token 设置在 header 里，Authorization: Bearer user_token' \
      '<hr>' \
      '<br>大部分 API 都可能返回以下 Response:' \
      '<ul>' \
        '<li>401: user token 不合法</li>' \
        '<li>403: 没有权限访问资源</li>' \
        '<li>404: 找不到指定的资源</li>' \
        '<li>500: 服务器错误</li>' \
      '</ul>' \
      '<br>这几个 Response 在这里统一说明，不列入某个 API 的详细说明里。' \
      '<hr>' \
      '<br>参数类型为date-time的，支持以下几种字符串格式:' \
      '<ul>' \
        '<li>2016-08-18 10:00:00，不带时区信息，默认为本地时间(东8区)</li>' \
        '<li>2016-08-18 10:00:00 +0800 或 2016-08-18T10:00:00+0800，带时区信息</li>' \
        '<li>2016-08-18 02:00:00 UTC 或 2016-08-18T02:00:00Z UTC，UTC时间</li>' \
      '</ul>' \
      '<br>参数类型为date的，一律为 2016-08-18 格式的字符串' \
      '<br>' \
    end
    module_function :api_doc_description
  end

  def current_user
    @current_user
  end

  protected

  def authenticate
    token = request.headers['Authorization']
    if token.blank?
      logger.warn("handle_401: token is blank, header: #{request.headers['Authorization']}")
      handle_error(code: 402, error:"Token is blank.") and return
    end

    begin
      token = token.gsub(/ |Bearer|\"/,"")
      payload = JWT.decode(token, Rails.application.credentials.user_token_secret).first
      raise unless payload.present?
    rescue
      logger.warn("Invalid token: '" + token + "'")
      handle_error(code: 403, error:"Invalid token.") and return
    end

    user = User.where(id:payload["user_id"].to_i).first

    if !user.present? or user.token!=token or (Time.now.to_i > payload["exp"].to_i)
      logger.warn("handle_401: user is invalid or token invalid, user_id: #{user.id}")
      handle_error(code: 403, error:"User is invalid or token invalid.") and return
    end

    @current_user = user
  end

  def handle_error(code: 1, error: nil, message: nil, reason: nil, detail: nil)
    result = {:code=>code}
    if !Rails.env.production?
      result[:message] = message ||= "#{error.class.try(:name)}: #{error.try(:message)}"
    else
      result[:message] = message ||= 'Internal Server Error'
    end
    result[:error] = error unless error.nil?
    result[:reason] = reason unless reason.nil?
    result[:detail] = detail unless detail.nil?

    render :json => result.to_json
  end

  def parse_array_params(*keys)
    keys.each do |key|
      if params[key].present? && !params[key].is_a?(Array)
        params[key] = params[key].split(',').map(&:strip)
      end
    end
  end

  def parse_json_params(*keys)
    keys.each do |key|
      if params[key].present? && params[key].is_a?(String)
        params[key] = JSON.parse(params[key])
      end
    end
  end
end