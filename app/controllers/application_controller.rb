class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def split_order_param order
    if order
      return order.split("|")
    else
      [:name_sort, "ASC"]
    end
  end

end
