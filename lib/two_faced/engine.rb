require 'two_faced'
require 'rails'

module TwoFaced
  class Engine < Rails::Engine

    config.mount_at = '/'

  end
end