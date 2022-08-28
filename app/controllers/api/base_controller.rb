module Api
  class BaseController < ApplicationController
    include Response
    skip_before_action :verify_authenticity_token
    before_action :set_pagination_params
    attr_reader :current_user
    attr_reader :pagination_params
    before_action :authenticate_user
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error

    private

    def authenticate_user
      command = AuthorizeApiRequest.new(request.headers).call
      if command.success?
        @current_user = command.result
      else
        json_error_response('Not Authorized', command.errors)
      end
    end

    def set_pagination_params
      @pagination_params = {
              page: params[:page] || 1,
              limit: params[:limit] || 10,
              names_limit: params[:limit].present? ? params[:limit] : 30
      }
    end

    def record_not_found_error
      json_error_response('Record Not Found.', params)
    end

  end
end
