module Yogy
  module Utils
    def self.yogies_to_array( yogies )
      yogies.split('#').drop(1).map { |item| item[/[[:word:] ]+/].strip.gsub(/\s+/, '_') }
    end
  end
end

