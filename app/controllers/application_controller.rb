def help
  Helper.instance
end



class Helper
  include Singleton
  include ActionView::Helpers::TextHelper
end



class ApplicationController < ActionController::Base
  protect_from_forgery
end
