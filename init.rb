ActionController::Base.helper Handicraft::Helper

ActionController::Base.class_eval do
  include Handicraft::ControllerHelper
end
