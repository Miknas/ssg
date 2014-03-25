class Api::V1::ApiController < ActionController::Base
  before_filter :check_token

  ActionController::Renderers.add :api_response do |obj, options|
    resp = Api::V1::Response.new
    resp.status = { :code => 0, :message => :ok }
    resp.document = obj

    self.content_type ||= Mime::Type.lookup('application/json')
    self.response_body = resp.to_json
  end


  rescue_from Exception do |exception|
    resp = Api::V1::Response.new
    
    if (exception.instance_of?(Api::V1::ApiError))
      resp.status = { :code => exception.api_code, :message => exception.api_msg }
    else
      resp.status = { :code => 400, :message => 'Bad Request' }

      logger.error exception.message
      logger.error exception.backtrace.join("\n")
    end

    render :json => resp.to_json, :status => 400
  end

  def check_token
    @api_user = User.where(params[:access_token]).first
  end

  def define_required(*required)
    required.each do |req_param|
      if (!params.has_key?(req_param)) 
        raise Api::V1::ApiError.missing_param(req_param.to_s)
      end
    end
  end

end