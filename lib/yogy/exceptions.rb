module Yogy
  module Exceptions
    class ImageInvalid < StandardError; end
    class ImageBlinded < StandardError; end
    class ImageDeleted < StandardError; end
    class UserDisabled < StandardError; end
    class AlreadyLiked < StandardError; end
    class AlreadyDisliked < StandardError; end
    class InternalError < StandardError; end
  end
end
