class Api::V1Controller < ApiController
  skip_before_action :verify_authenticity_token
end
