module TwoFaced
  class Railtie < Rails::Railtie
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.send :extend, TwoFaced::Hook
    end
  end

end