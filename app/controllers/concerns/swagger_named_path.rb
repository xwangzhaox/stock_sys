module SwaggerNamedPath
  extend ActiveSupport::Concern

  ROUTE_MAPPING = Hash[
    Rails.application.routes.routes.map do |r|
      next if r.name.nil?
      [r.name.to_sym, r.path.spec.to_s.sub(/\(\.:format\)\z/, '').gsub(/\/:(.+?)(\/|\z)/, '/{\1}\2')]
    end.compact
  ].freeze

  module ClassMethods
    def swagger_named_path(name, &block)
      swagger_path(ROUTE_MAPPING[name.to_sym], &block)
    end
  end
end
