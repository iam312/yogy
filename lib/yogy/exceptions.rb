module Yogy
  module Exceptions
    class ImageInvalid < StandardError; end
    class AlreadyLiked < StandardError; end
    class AlreadyDisliked < StandardError; end
  end
end
