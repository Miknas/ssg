class Api::V1::ApiError < StandardError
  def initialize(code, msg)
    @api_code = code
    @api_msg = msg
    super(msg)
  end

  def api_code
    @api_code
  end

  def api_msg
    @api_msg
  end

  def self.generic_error
    Api::V1::ApiError.new(400, 'Bad request')
  end

  def self.invalid_user
    Api::V1::ApiError.new(600, 'Invalid credentials')
  end

  def self.missing_param(name)
    Api::V1::ApiError.new(400, "Missing required param : #{name}")
  end
end