class ApiDocsController < ActionController::Base
  include Swagger::Blocks

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES_V1 = [
    Api::V1::BaseController,
    Api::V1::SessionController,
    self
  ].freeze

  layout 'api_doc'

  def index
  end

  def api_v1
    respond_to do |format|
      format.html
      format.json do
        render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES_V1)
      end
    end
  end
end
