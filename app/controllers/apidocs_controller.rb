class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do

    key :swagger, '2.0'

    info do
      key :version, '1.0.0'
      key :title, 'DigitalExpress API'
      key :description, 'API Documentation for DigitalExpress'
    end

    tag do
      key :name, 'Authentication'
      key :description, 'Authentication APIs'
    end
    tag do
      key :name, 'Users'
      key :description, 'Users APIs'
    end

    key :host, "localhost:3000"
    key :basePath, '/api/v1/'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::SwaggerDocs::AuthDoc,
    Api::V1::SwaggerDocs::UsersDoc,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
