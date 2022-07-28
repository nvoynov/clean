# frozen_string_literal: true

require_relative "clean/version"
require_relative 'clean/sentry'
require_relative 'clean/service'
require_relative 'clean/gateway'
require_relative 'clean/extra'

module Clean

  def self.root
    File.dirname __dir__
  end

end
