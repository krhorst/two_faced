module TwoFaced::Hook
  def acts_as_overrideable
    include TwoFaced::ModelExtensions
  end
end