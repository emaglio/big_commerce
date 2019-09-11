module Bigcommerce
  module Errors
    class AuthError < StandardError; end
    class NotFoundError < StandardError; end
    class DuplicateError < StandardError; end
    class InvalidObjectError < StandardError; end
    class UnknownError < StandardError; end
  end
end
