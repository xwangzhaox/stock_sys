class Api::V1::BaseController < ActionController::Base
  include ApiBaseSharings

  swagger_root do
    key :swagger, '2.0'
    key :basePath, '/'
    key :consumes, ['application/json']
    key :produces, ['application/json']
    info do
      key :version, '1.0'
      key :title, 'API V1'
      key :description, 'API V1'
    end
    tag do
      key :name, 'Session'
      key :description, '用户'
    end
  end
end
