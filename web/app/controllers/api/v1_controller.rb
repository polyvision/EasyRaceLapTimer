class Api::V1Controller < ApiController
  skip_before_filter :verify_authenticity_token
end
