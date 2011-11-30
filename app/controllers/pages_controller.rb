class PagesController < ApplicationController
  def contact
    @title = "Contact"
  end

  def home
    @title = "Home"
    if user_signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page])
      alerts = current_user.alerts

      if alerts
        alerts.each do |a|
          if a.date <= Date.today
          message = "Expired : "
          message << a.title
          message << "- $"
          message << a.amount.to_s
          gflash :warning => message
          elsif a.date <= Date.today + 3
          days = (a.date - Date.today).to_i
          message = "Due in "
          message << help.pluralize(days, " day")
          message << " - "
          message << a.title
          message << " $"
          message << a.amount.to_s
          gflash :notice => message
          end
        end
      end

    end
  end

end

